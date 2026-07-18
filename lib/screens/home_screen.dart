import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/shapes.dart';
import '../engine/generator.dart';
import '../models/shape.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ShapeCard(
                    shape: allShapes[i],
                    index: i,
                  ).animate().fadeIn(
                        delay: Duration(milliseconds: 100 + i * 80),
                        duration: 400.ms,
                      ),
                  childCount: allShapes.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nodaku',
            style: Theme.of(context).textTheme.displayLarge,
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.3, end: 0, duration: 500.ms),
          const SizedBox(height: 6),
          Text(
            'Place numbers so every line multiplies to its clue.',
            style: Theme.of(context).textTheme.bodyMedium,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _ShapeCard extends StatelessWidget {
  final PuzzleShape shape;
  final int index;

  const _ShapeCard({required this.shape, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchGame(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _ShapeIcon(circleCount: shape.circleCount),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shape.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${shape.circleCount} circles · ${shape.lines.length} lines',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  void _launchGame(BuildContext context) {
    final puzzle = PuzzleGenerator(shape).generate();
    if (puzzle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not generate a puzzle. Try again!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(puzzle: puzzle)),
    );
  }
}

class _ShapeIcon extends StatelessWidget {
  final int circleCount;

  const _ShapeIcon({required this.circleCount});

  @override
  Widget build(BuildContext context) {
    final Color bg = _colorFor(circleCount);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        '$circleCount',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: bg,
        ),
      ),
    );
  }

  Color _colorFor(int n) {
    if (n <= 3) return AppTheme.circleCorrect;
    if (n <= 5) return AppTheme.primary;
    if (n <= 7) return const Color(0xFFFFB347);
    return AppTheme.circleWrong;
  }
}
