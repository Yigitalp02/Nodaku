import 'dart:math';
import 'package:flutter/material.dart';
import '../models/shape.dart';
import '../theme/app_theme.dart';

/// Paints the static structure of a puzzle: lines and product labels.
/// Circles are drawn as separate widgets on top for tap interaction.
class PuzzleBoardPainter extends CustomPainter {
  final PuzzleShape shape;
  final Map<int, int> lineProducts;
  final Map<int, bool> lineStatuses;
  final Map<int, bool> labelAtStart;

  /// Pre-computed node positions in canvas coordinates.
  final Map<int, Offset> nodePositions;

  PuzzleBoardPainter({
    required this.shape,
    required this.lineProducts,
    required this.lineStatuses,
    required this.labelAtStart,
    required this.nodePositions,
  });

  static const double _stubLength = 28.0;
  static const double _productFontSize = 13.0;

  @override
  void paint(Canvas canvas, Size size) {
    _drawLines(canvas);
    _drawStubsAndProducts(canvas);
  }

  void _drawLines(Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < shape.lines.length; i++) {
      final line = shape.lines[i];
      final satisfied = lineStatuses[i] ?? false;
      paint.color = satisfied ? AppTheme.circleCorrect : AppTheme.lineColor;

      final positions = line.nodeIds.map((id) => nodePositions[id]!).toList();
      for (int j = 0; j < positions.length - 1; j++) {
        canvas.drawLine(positions[j], positions[j + 1], paint);
      }
    }
  }

  void _drawStubsAndProducts(Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.lineColor;

    for (int i = 0; i < shape.lines.length; i++) {
      final line = shape.lines[i];
      final product = lineProducts[i]!;
      final satisfied = lineStatuses[i] ?? false;

      final positions = line.nodeIds.map((id) => nodePositions[id]!).toList();
      if (positions.length < 2) continue;

      // Use the LOCAL segment direction at each endpoint so the stub continues
      // the actual angle of the line entering that circle, not the
      // overall first→last direction (which is wrong for non-straight lines).
      final startDir = _unit(positions[0] - positions[1]);
      final endDir   = _unit(positions.last - positions[positions.length - 2]);

      final stubStart = positions.first + startDir * _stubLength;
      final stubEnd   = positions.last  + endDir   * _stubLength;

      paint.color = satisfied ? AppTheme.circleCorrect : AppTheme.lineColor;
      canvas.drawLine(positions.first, stubStart, paint);
      canvas.drawLine(positions.last,  stubEnd,   paint);

      final atStart  = labelAtStart[i] ?? false;
      final labelTip = atStart ? stubStart : stubEnd;
      final labelDir = atStart ? startDir  : endDir;
      _drawProductLabel(canvas, labelTip, labelDir, product, satisfied);
    }
  }

  static Offset _unit(Offset v) {
    final d = v.distance;
    return d == 0 ? Offset.zero : v / d;
  }

  void _drawProductLabel(
    Canvas canvas,
    Offset stubTip,
    Offset direction,
    int product,
    bool satisfied,
  ) {
    final textColor =
        satisfied ? AppTheme.circleCorrect : AppTheme.productColor;

    final tp = TextPainter(
      text: TextSpan(
        text: '$product',
        style: TextStyle(
          fontSize: _productFontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Place the label centre directly along the line direction, just beyond
    // the stub tip. The half-diagonal of the text bounding box gives enough
    // clearance so the text doesn't overlap the stub line itself.
    final halfDiag = (tp.width * direction.dx.abs() + tp.height * direction.dy.abs()) / 2;
    final labelCenter = stubTip + direction * (halfDiag + 4);

    tp.paint(
      canvas,
      labelCenter - Offset(tp.width / 2, tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(PuzzleBoardPainter oldDelegate) =>
      oldDelegate.lineStatuses != lineStatuses ||
      oldDelegate.labelAtStart != labelAtStart;
}

/// Computes canvas-space positions for all nodes, given a bounding [size].
/// Adds [padding] on all sides and scales the abstract grid to fit.
Map<int, Offset> computeNodePositions(
  PuzzleShape shape,
  Size size, {
  double padding = 52.0,
}) {
  if (shape.nodes.isEmpty) return {};

  final xs = shape.nodes.map((n) => n.x);
  final ys = shape.nodes.map((n) => n.y);
  final minX = xs.reduce(min);
  final maxX = xs.reduce(max);
  final minY = ys.reduce(min);
  final maxY = ys.reduce(max);

  final gridW = maxX - minX;
  final gridH = maxY - minY;

  final drawW = size.width - padding * 2;
  final drawH = size.height - padding * 2;

  final scaleX = gridW == 0 ? 1.0 : drawW / gridW;
  final scaleY = gridH == 0 ? 1.0 : drawH / gridH;
  final scale = min(scaleX, scaleY);

  final offsetX = padding + (drawW - gridW * scale) / 2;
  final offsetY = padding + (drawH - gridH * scale) / 2;

  return {
    for (final n in shape.nodes)
      n.id: Offset(
        offsetX + (n.x - minX) * scale,
        offsetY + (n.y - minY) * scale,
      ),
  };
}
