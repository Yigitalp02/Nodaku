import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';

/// Persistent number bar always shown at the bottom of the game screen.
/// Tap a circle first, then tap a number to fill it.
class NumberBar extends StatelessWidget {
  final GameState gameState;
  final bool isHowToPlayOpen;
  final VoidCallback onHowToPlayToggle;

  /// Called after a number is placed so the parent can auto-check.
  final VoidCallback? onNumberPlaced;

  const NumberBar({
    super.key,
    required this.gameState,
    required this.isHowToPlayOpen,
    required this.onHowToPlayToggle,
    this.onNumberPlaced,
  });

  @override
  Widget build(BuildContext context) {
    final n = gameState.puzzle.shape.circleCount;
    final used = gameState.usedValues;
    final selected = gameState.selectedNodeId;
    final selectedValue = selected != null ? gameState.valueAt(selected) : null;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Action buttons row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.lightbulb_outline_rounded,
                    label: 'Hint (${gameState.hintsRemaining})',
                    onTap: gameState.hasHints ? gameState.useHint : null,
                    color: const Color(0xFFFFB347),
                  ),
                  _ActionButton(
                    icon: Icons.undo_rounded,
                    label: 'Undo',
                    onTap: gameState.canUndo ? gameState.undo : null,
                    color: AppTheme.textSecondary,
                  ),
                  _ActionButton(
                    icon: Icons.backspace_outlined,
                    label: 'Erase',
                    onTap: selected != null ? gameState.eraseSelected : null,
                    color: AppTheme.circleWrong,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ── Number grid ──
              _NumberGrid(
                circleCount: n,
                usedValues: used,
                selectedValue: selectedValue,
                isCircleSelected: selected != null,
                onNumberTap: (v) {
                  if (selected != null) {
                    gameState.placeValueAtSelected(v);
                    onNumberPlaced?.call();
                  }
                },
              ),
              const SizedBox(height: 4),
              // ── How to play toggle ──
              _HowToPlayToggle(
                isOpen: isHowToPlayOpen,
                onTap: onHowToPlayToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _HowToPlayToggle extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _HowToPlayToggle({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Text(
              'How to play?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textSecondary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: 150.ms,
        opacity: enabled ? 1.0 : 0.35,
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _NumberGrid extends StatelessWidget {
  final int circleCount;
  final Set<int> usedValues;
  final int? selectedValue;
  final bool isCircleSelected;
  final void Function(int) onNumberTap;

  const _NumberGrid({
    required this.circleCount,
    required this.usedValues,
    required this.selectedValue,
    required this.isCircleSelected,
    required this.onNumberTap,
  });

  @override
  Widget build(BuildContext context) {
    // Split numbers into rows of 4.
    const cols = 4;
    final rows = <List<int>>[];
    var row = <int>[];
    for (int i = 1; i <= circleCount; i++) {
      row.add(i);
      if (row.length == cols) {
        rows.add(row);
        row = [];
      }
    }
    if (row.isNotEmpty) rows.add(row);

    return Column(
      children: rows
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: r
                    .map(
                      (v) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _NumberTile(
                            value: v,
                            isActive: selectedValue == v,
                            isUsed: usedValues.contains(v),
                            isCircleSelected: isCircleSelected,
                            onTap: () => onNumberTap(v),
                          ).animate(
                            key: ValueKey(v),
                          ).scale(
                            begin: const Offset(0.85, 0.85),
                            end: const Offset(1, 1),
                            duration: 300.ms,
                            delay: Duration(milliseconds: (v - 1) * 25),
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _NumberTile extends StatelessWidget {
  final int value;
  final bool isActive;
  final bool isUsed;
  final bool isCircleSelected;
  final VoidCallback onTap;

  const _NumberTile({
    required this.value,
    required this.isActive,
    required this.isUsed,
    required this.isCircleSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isActive
        ? AppTheme.primary
        : isUsed
            ? AppTheme.circleEmpty.withOpacity(0.5)
            : AppTheme.circleEmpty;

    final Color fg = isActive
        ? Colors.white
        : isUsed
            ? AppTheme.textSecondary.withOpacity(0.6)
            : AppTheme.textPrimary;

    return GestureDetector(
      onTap: isCircleSelected ? onTap : null,
      child: AnimatedContainer(
        duration: 150.ms,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isCircleSelected
                ? fg
                : AppTheme.textSecondary.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
