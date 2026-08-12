import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../engine/generator.dart';
import '../models/game_state.dart';
import '../models/puzzle.dart';
import '../theme/app_theme.dart';
import '../widgets/puzzle_board_painter.dart';
import '../widgets/number_bar.dart';

class GameScreen extends StatefulWidget {
  final Puzzle puzzle;

  const GameScreen({super.key, required this.puzzle});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  bool _showSolveAnimation = false;
  bool _showErrorBanner = false;
  bool _howToPlayOpen = false;

  @override
  void initState() {
    super.initState();
    _gameState = GameState(widget.puzzle);
  }

  void _onCircleTap(int nodeId) {
    setState(() => _gameState.selectNode(nodeId));
  }

  /// Called by NumberBar after every number placement.
  void _onNumberPlaced() {
    setState(() {});
    if (_gameState.isBoardFull && _gameState.status == GameStatus.playing) {
      _autoCheck();
    }
  }

  void _autoCheck() {
    final solved = _gameState.checkSolution();
    setState(() {});
    if (solved) {
      // Short delay so the player sees the last circle fill before animation.
      Future.delayed(400.ms, () {
        if (mounted) setState(() => _showSolveAnimation = true);
      });
    } else {
      setState(() => _showErrorBanner = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showErrorBanner = false);
      });
    }
  }

  void _reset() {
    setState(() {
      _gameState.reset();
      _showSolveAnimation = false;
      _showErrorBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppTheme.textPrimary),
        title: Text(
          widget.puzzle.shape.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded,
                size: 18, color: AppTheme.textSecondary),
            label: Text(
              'Reset',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _gameState,
        builder: (context, _) {
          return Stack(
            children: [
              Column(
                children: [
                  _DifficultyBadge(difficulty: widget.puzzle.difficulty)
                      .animate()
                      .fadeIn(duration: 400.ms),
                  // ── Inline error banner (fixed-height slot so board never shifts) ──
                  SizedBox(
                    height: 52,
                    child: _showErrorBanner ? const _ErrorBanner() : null,
                  ),
                  // ── Puzzle board + how-to-play overlay ──
                  Expanded(
                    child: Stack(
                      children: [
                        FractionalTranslation(
                          translation: const Offset(0, -0.05),
                          child: _PuzzleBoard(
                            gameState: _gameState,
                            onCircleTap: _onCircleTap,
                          ),
                        ),
                        AnimatedSlide(
                          offset: _howToPlayOpen
                              ? Offset.zero
                              : const Offset(0, 1),
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOut,
                          child: AnimatedOpacity(
                            opacity: _howToPlayOpen ? 1 : 0,
                            duration: const Duration(milliseconds: 220),
                            child: IgnorePointer(
                              ignoring: !_howToPlayOpen,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {},
                                  child: const _HowToPlayPanel(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ── Persistent number bar ──
                  NumberBar(
                    gameState: _gameState,
                    isHowToPlayOpen: _howToPlayOpen,
                    onHowToPlayToggle: () =>
                        setState(() => _howToPlayOpen = !_howToPlayOpen),
                    onNumberPlaced: _onNumberPlaced,
                  ),
                ],
              ),

              // ── How-to-play tap-outside barrier (full body coverage) ──
              if (_howToPlayOpen)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _howToPlayOpen = false),
                  ),
                ),
              // ── Solve animation overlay ──
              if (_showSolveAnimation)
                Positioned.fill(
                  child: _SolveAnimation(
                    puzzle: widget.puzzle,
                    onMenu: () => Navigator.pop(context),
                    onNext: () {
                      final next =
                          PuzzleGenerator(widget.puzzle.shape).generate();
                      if (next == null) {
                        Navigator.pop(context);
                        return;
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GameScreen(puzzle: next)),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Puzzle board
// ─────────────────────────────────────────────────────────────────────────────

class _PuzzleBoard extends StatelessWidget {
  final GameState gameState;
  final void Function(int nodeId) onCircleTap;

  const _PuzzleBoard({required this.gameState, required this.onCircleTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final nodePositions = computeNodePositions(
          gameState.puzzle.shape,
          size,
          padding: 60,
        );

        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: PuzzleBoardPainter(
                shape: gameState.puzzle.shape,
                lineProducts: gameState.puzzle.lineProducts,
                lineStatuses: gameState.lineStatuses,
                labelAtStart: gameState.puzzle.labelAtStart,
                nodePositions: nodePositions,
              ),
            ),
            for (final node in gameState.puzzle.shape.nodes)
              _CircleWidget(
                nodeId: node.id,
                position: nodePositions[node.id]!,
                value: gameState.valueAt(node.id),
                isSelected: gameState.selectedNodeId == node.id,
                isWrong: gameState.wrongNodes.contains(node.id),
                isSolved: gameState.status == GameStatus.solved,
                onTap: () => onCircleTap(node.id),
              ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circle widget
// ─────────────────────────────────────────────────────────────────────────────

class _CircleWidget extends StatelessWidget {
  final int nodeId;
  final Offset position;
  final int? value;
  final bool isSelected;
  final bool isWrong;
  final bool isSolved;
  final VoidCallback onTap;

  const _CircleWidget({
    required this.nodeId,
    required this.position,
    required this.value,
    required this.isSelected,
    required this.isWrong,
    required this.isSolved,
    required this.onTap,
  });

  static const double _radius = 26.0;

  @override
  Widget build(BuildContext context) {
    final Color bg = isSolved
        ? AppTheme.circleCorrect
        : isWrong
            ? AppTheme.circleWrong
            : isSelected
                ? AppTheme.primary
                : value != null
                    ? AppTheme.circleFilled
                    : AppTheme.circleEmpty;

    final Color fg = (value != null || isSolved || isSelected)
        ? Colors.white
        : AppTheme.textSecondary;

    return Positioned(
      left: position.dx - _radius,
      top: position.dy - _radius,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 180.ms,
          width: _radius * 2,
          height: _radius * 2,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: (isSolved
                        ? AppTheme.circleCorrect
                        : isWrong
                            ? AppTheme.circleWrong
                            : isSelected
                                ? AppTheme.primary
                                : AppTheme.primary)
                    .withOpacity(isSelected || value != null ? 0.4 : 0.12),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: 150.ms,
            child: Text(
              value != null ? '$value' : '',
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Solve animation overlay
// ─────────────────────────────────────────────────────────────────────────────

class _SolveAnimation extends StatefulWidget {
  final Puzzle puzzle;
  final VoidCallback onMenu;
  final VoidCallback onNext;

  const _SolveAnimation({
    required this.puzzle,
    required this.onMenu,
    required this.onNext,
  });

  @override
  State<_SolveAnimation> createState() => _SolveAnimationState();
}

class _SolveAnimationState extends State<_SolveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanY;    // 0 → 1 scan line position
  late Animation<double> _glowOpacity; // fade in glow overlay

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scanY = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    );

    _glowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // ── Scan line effect ──
            Positioned.fill(
              child: ClipRect(
                child: Stack(
                  children: [
                    // Green scan bar
                    Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.height * _scanY.value - 80,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.circleCorrect.withOpacity(0),
                              AppTheme.circleCorrect.withOpacity(0.25),
                              AppTheme.circleCorrect.withOpacity(0.5),
                              AppTheme.circleCorrect.withOpacity(0.25),
                              AppTheme.circleCorrect.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Green glow overlay after scan ──
            Opacity(
              opacity: _glowOpacity.value * 0.15,
              child: Container(color: AppTheme.circleCorrect),
            ),

            // ── Success card ──
            if (_glowOpacity.value > 0)
              Align(
                alignment: const Alignment(0, -0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Opacity(
                    opacity: _glowOpacity.value,
                    child: Transform.scale(
                      scale: 0.7 + _glowOpacity.value * 0.3,
                      child: _SuccessCard(
                        puzzle: widget.puzzle,
                        onMenu: widget.onMenu,
                        onNext: widget.onNext,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final Puzzle puzzle;
  final VoidCallback onMenu;
  final VoidCallback onNext;

  const _SuccessCard({
    required this.puzzle,
    required this.onMenu,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.circleCorrect.withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.circleCorrect.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppTheme.circleCorrect,
              size: 36,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 16),
          Text(
            'Solved!',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.circleCorrect,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            puzzle.shape.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onMenu,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: const BorderSide(color: AppTheme.lineColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Menu'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Difficulty badge
// ─────────────────────────────────────────────────────────────────────────────

class _DifficultyBadge extends StatelessWidget {
  final Difficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (difficulty) {
      Difficulty.easy => ('Easy', AppTheme.circleCorrect),
      Difficulty.medium => ('Medium', const Color(0xFFFFB347)),
      Difficulty.hard => ('Hard', AppTheme.circleWrong),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ── How-to-play panel (overlay, lives inside the puzzle Stack) ───────────────

class _HowToPlayPanel extends StatelessWidget {
  const _HowToPlayPanel();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        icon: Icons.circle_outlined,
        title: 'Fill every circle',
        body:
            'Place numbers 1 – N into the N circles on the board. Each number must appear exactly once.',
      ),
      (
        icon: Icons.calculate_outlined,
        title: 'Match the line products',
        body:
            'The number at the end of each line is the product of all circles on that line. Your placement must satisfy every line.',
      ),
      (
        icon: Icons.touch_app_outlined,
        title: 'Tap to select & place',
        body:
            'Tap a circle to select it (it glows), then tap a number from the bar below to place it.',
      ),
      (
        icon: Icons.lightbulb_outline_rounded,
        title: 'Stuck? Use a hint',
        body:
            'Tap the Hint button to reveal one correct number. You have 3 hints per puzzle.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight - 8),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to play',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: steps.map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(s.icon,
                                    size: 16, color: AppTheme.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      s.body,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Inline error banner ──────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.circleWrong,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Some answers are incorrect — keep trying!',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: -0.5, end: 0, duration: 250.ms, curve: Curves.easeOut)
        .fadeIn(duration: 200.ms);
  }
}
