/// A single node (circle) in the puzzle layout.
class PuzzleNode {
  final int id;

  /// Grid coordinates used for rendering (arbitrary units, scaled to screen).
  final double x;
  final double y;

  const PuzzleNode({required this.id, required this.x, required this.y});
}

/// A line that passes through two or more nodes.
/// The product of the values placed in those nodes must equal [product].
class PuzzleLine {
  /// Ordered list of node IDs along this line (left-to-right or top-to-bottom).
  final List<int> nodeIds;

  const PuzzleLine(this.nodeIds);

  int get length => nodeIds.length;
}

/// A shape template: the fixed topology of circles and lines.
/// The same shape is reused across many generated puzzles.
class PuzzleShape {
  final String id;
  final String name;
  final int circleCount;
  final List<PuzzleNode> nodes;
  final List<PuzzleLine> lines;

  const PuzzleShape({
    required this.id,
    required this.name,
    required this.circleCount,
    required this.nodes,
    required this.lines,
  });

  PuzzleNode nodeById(int id) => nodes.firstWhere((n) => n.id == id);
}
