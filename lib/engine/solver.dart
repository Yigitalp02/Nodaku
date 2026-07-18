import '../models/shape.dart';

/// Backtracking solver for the multiplication puzzle.
///
/// Given a shape and a set of line product constraints, finds all valid
/// assignments of values 1..N to nodes. Used both for:
///   1. Uniqueness verification during generation.
///   2. Hint generation.
class PuzzleSolver {
  final PuzzleShape shape;
  final Map<int, int> lineProducts;

  PuzzleSolver({required this.shape, required this.lineProducts});

  /// Returns up to [maxSolutions] valid solutions.
  /// If more than 1 solution is found the puzzle is not unique.
  List<Map<int, int>> solve({int maxSolutions = 2}) {
    final n = shape.circleCount;
    final nodeIds = shape.nodes.map((e) => e.id).toList();
    final assignment = <int, int>{};
    final solutions = <Map<int, int>>[];

    _backtrack(nodeIds, 0, n, assignment, solutions, maxSolutions);
    return solutions;
  }

  void _backtrack(
    List<int> nodeIds,
    int depth,
    int n,
    Map<int, int> assignment,
    List<Map<int, int>> solutions,
    int maxSolutions,
  ) {
    if (solutions.length >= maxSolutions) return;

    if (depth == nodeIds.length) {
      // All nodes assigned — verify all line products.
      if (_allLinesValid(assignment, checkPartial: false)) {
        solutions.add(Map.from(assignment));
      }
      return;
    }

    final nodeId = nodeIds[depth];
    final used = assignment.values.toSet();

    for (int v = 1; v <= n; v++) {
      if (used.contains(v)) continue;
      assignment[nodeId] = v;

      // Prune: check lines that are fully assigned.
      if (_allLinesValid(assignment, checkPartial: true)) {
        _backtrack(nodeIds, depth + 1, n, assignment, solutions, maxSolutions);
      }

      if (solutions.length >= maxSolutions) {
        assignment.remove(nodeId);
        return;
      }
    }

    assignment.remove(nodeId);
  }

  /// Returns false if any fully-assigned line has a wrong product.
  /// If [checkPartial] is true, also prunes lines where partial product
  /// already exceeds the target (since all values ≥ 1 and multiplying only
  /// increases the product).
  bool _allLinesValid(Map<int, int> assignment, {required bool checkPartial}) {
    for (int i = 0; i < shape.lines.length; i++) {
      final line = shape.lines[i];
      final target = lineProducts[i]!;
      int product = 1;
      bool complete = true;

      for (final nodeId in line.nodeIds) {
        final v = assignment[nodeId];
        if (v == null) {
          complete = false;
        } else {
          product *= v;
        }
      }

      if (complete) {
        if (product != target) return false;
      } else if (checkPartial) {
        // Since all values ≥ 1, partial product can only grow or stay the same.
        // If it already exceeds target, prune.
        if (product > target) return false;
        // Also prune if target is not divisible by the current partial product.
        if (target % product != 0) return false;
      }
    }
    return true;
  }
}
