import 'shape.dart';

enum Difficulty { easy, medium, hard }

/// A generated puzzle: a shape + the product clues for every line.
class Puzzle {
  final PuzzleShape shape;

  /// Map from line index → the product the player must achieve.
  final Map<int, int> lineProducts;

  /// Map from line index → whether to show the product label at the START
  /// (first node) end of the line. false = show at the END (last node).
  /// Randomised per puzzle so clues are spread around the shape.
  final Map<int, bool> labelAtStart;

  final Difficulty difficulty;

  /// The unique correct answer: nodeId → value (1..N).
  final Map<int, int> solution;

  const Puzzle({
    required this.shape,
    required this.lineProducts,
    required this.labelAtStart,
    required this.difficulty,
    required this.solution,
  });
}
