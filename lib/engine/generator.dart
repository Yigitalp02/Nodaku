import 'dart:math';
import '../models/puzzle.dart';
import '../models/shape.dart';
import 'solver.dart';

/// Generates valid, uniquely-solvable puzzles for a given shape.
class PuzzleGenerator {
  final PuzzleShape shape;
  final Random _rng;

  PuzzleGenerator(this.shape, {int? seed}) : _rng = Random(seed);

  /// Attempts to generate a puzzle, retrying up to [maxAttempts] times.
  /// Returns null if no unique puzzle could be found.
  Puzzle? generate({int maxAttempts = 200}) {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final puzzle = _tryGenerate();
      if (puzzle != null) return puzzle;
    }
    return null;
  }

  Puzzle? _tryGenerate() {
    final n = shape.circleCount;

    // 1. Random shuffle of 1..N → assign to nodes.
    final values = List.generate(n, (i) => i + 1)..shuffle(_rng);
    final nodeIds = shape.nodes.map((e) => e.id).toList();
    final assignment = <int, int>{
      for (int i = 0; i < nodeIds.length; i++) nodeIds[i]: values[i],
    };

    // 2. Compute line products from the assignment.
    final lineProducts = <int, int>{};
    for (int i = 0; i < shape.lines.length; i++) {
      int product = 1;
      for (final nodeId in shape.lines[i].nodeIds) {
        product *= assignment[nodeId]!;
      }
      lineProducts[i] = product;
    }

    // 3. Verify uniqueness via the solver.
    final solver = PuzzleSolver(shape: shape, lineProducts: lineProducts);
    final solutions = solver.solve(maxSolutions: 2);

    if (solutions.length != 1) return null; // Not unique.

    // 4. Assign label positions: spread clues around the shape by preferring
    //    the terminal node that currently has fewer labels near it.
    final labelAtStart = _assignLabelPositions();

    // 5. Rate difficulty based on solver search space.
    final difficulty = _rateDifficulty();

    return Puzzle(
      shape: shape,
      lineProducts: lineProducts,
      labelAtStart: labelAtStart,
      difficulty: difficulty,
      solution: assignment,
    );
  }

  /// For each line, decide whether to show its product label at the start
  /// (first node) or end (last node) of the line.
  ///
  /// Strategy: greedily assign each line's label to whichever terminal node
  /// currently has the fewest labels. Ties are broken randomly.
  Map<int, bool> _assignLabelPositions() {
    // labelCount[nodeId] = how many labels are already assigned near that node.
    final labelCount = <int, int>{
      for (final n in shape.nodes) n.id: 0,
    };

    // Process lines in a random order so the result varies per puzzle.
    final lineIndices = List.generate(shape.lines.length, (i) => i)
      ..shuffle(_rng);

    final labelAtStart = <int, bool>{};

    for (final i in lineIndices) {
      final line = shape.lines[i];
      final startNode = line.nodeIds.first;
      final endNode = line.nodeIds.last;

      final startCount = labelCount[startNode]!;
      final endCount = labelCount[endNode]!;

      bool atStart;
      if (startCount < endCount) {
        atStart = true;
      } else if (endCount < startCount) {
        atStart = false;
      } else {
        atStart = _rng.nextBool();
      }

      labelAtStart[i] = atStart;
      labelCount[atStart ? startNode : endNode] =
          (labelCount[atStart ? startNode : endNode]! + 1);
    }

    return labelAtStart;
  }

  Difficulty _rateDifficulty() {
    final n = shape.circleCount;
    if (n <= 3) return Difficulty.easy;
    if (n <= 6) return Difficulty.medium;
    return Difficulty.hard;
  }
}
