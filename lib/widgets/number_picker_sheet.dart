import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Bottom sheet that lets the player pick a number (1..N) to place.
class NumberPickerSheet extends StatelessWidget {
  final int circleCount;
  final Set<int> usedValues;
  final int? currentValue;
  final void Function(int value) onSelected;
  final VoidCallback onClear;

  const NumberPickerSheet({
    super.key,
    required this.circleCount,
    required this.usedValues,
    required this.currentValue,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Choose a number',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (int v = 1; v <= circleCount; v++)
                _NumberTile(
                  value: v,
                  isUsed: usedValues.contains(v) && currentValue != v,
                  isSelected: currentValue == v,
                  onTap: () => onSelected(v),
                ).animate().scale(
                      delay: Duration(milliseconds: (v - 1) * 30),
                      duration: 200.ms,
                      curve: Curves.easeOut,
                    ),
            ],
          ),
          const SizedBox(height: 12),
          if (currentValue != null)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear this circle'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.circleWrong,
              ),
            ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  final int value;
  final bool isUsed;
  final bool isSelected;
  final VoidCallback onTap;

  const _NumberTile({
    required this.value,
    required this.isUsed,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isSelected
        ? AppTheme.circleFilled
        : isUsed
            ? AppTheme.circleEmpty.withOpacity(0.4)
            : AppTheme.circleEmpty;
    final Color fg = isSelected
        ? Colors.white
        : isUsed
            ? AppTheme.textSecondary.withOpacity(0.5)
            : AppTheme.textPrimary;

    return GestureDetector(
      onTap: isUsed && !isSelected ? null : onTap,
      child: AnimatedContainer(
        duration: 150.ms,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          boxShadow: isSelected
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
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}
