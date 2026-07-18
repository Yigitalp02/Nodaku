import 'package:flutter_test/flutter_test.dart';
import 'package:noduka/engine/generator.dart';
import 'package:noduka/engine/solver.dart';
import 'package:noduka/data/shapes.dart';

void main() {
  group('Solver', () {
    test('l_5 finds exactly one solution', () {
      final generator = PuzzleGenerator(shapeL5, seed: 7);
      final puzzle = generator.generate();
      expect(puzzle, isNotNull);

      final solver = PuzzleSolver(
        shape: puzzle!.shape,
        lineProducts: puzzle.lineProducts,
      );
      final solutions = solver.solve(maxSolutions: 2);
      expect(solutions.length, 1);
    });
  });

  group('Generator', () {
    test('generates valid puzzle for all shapes', () {
      for (final shape in allShapes) {
        final puzzle = PuzzleGenerator(shape).generate();
        expect(puzzle, isNotNull,
            reason: 'Failed for shape: ${shape.id}');
      }
    });

    test('label positions vary across runs for same shape', () {
      final puzzles = List.generate(
        6,
        (_) => PuzzleGenerator(shapeL5).generate()!,
      );
      // At least one pair of puzzles should have different labelAtStart maps.
      final allSame = puzzles.every(
        (p) => p.labelAtStart.toString() == puzzles.first.labelAtStart.toString(),
      );
      expect(allSame, isFalse,
          reason: 'Label positions should vary across generated puzzles');
    });
  });
}
