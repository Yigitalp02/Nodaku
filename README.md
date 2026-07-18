# Nodaku

A mobile math puzzle game built with Flutter. Place numbers into circles so that the product of every connected line matches the clue shown at that line's tip.

---

## Game Rules

- The puzzle board consists of N circles connected by lines.
- Each circle must contain a unique number from 1 to N.
- The small number shown at the end of each line is the product of all circles on that line.
- The puzzle is solved when every line's product is satisfied simultaneously.

The game is inspired by a classic pencil-and-paper puzzle from a mathematics book.

---

## Features

- Procedural puzzle generation with uniqueness verification via backtracking solver
- Four hand-designed puzzle shapes with varying difficulty (Tutorial, Grid, Triangle, L-Shape)
- Difficulty rating (Easy / Medium / Hard) computed from constraint density
- Randomised clue label placement — the tip of a line can appear on either end, spread intelligently to avoid visual crowding
- Persistent number bar with Hint, Undo, and Erase actions
- Auto-check: the puzzle automatically validates when all circles are filled
- Scan-and-glow solve animation on correct completion
- Inline error banner (appears below the difficulty badge, never covers the number bar)
- Collapsible "How to play" panel that overlays the puzzle without shifting the layout
- Menu and Next navigation from the success screen
- Portrait-only orientation lock

---

## Project Structure

```
lib/
  data/
    shapes.dart          # Hand-designed puzzle shapes (node coordinates + line definitions)
  engine/
    generator.dart       # Procedural puzzle generator (random permutations + uniqueness check)
    solver.dart          # Backtracking solver used by the generator and hint system
  models/
    game_state.dart      # ChangeNotifier managing board values, selection, undo history, hints
    puzzle.dart          # Puzzle data class (shape, line products, label positions, solution)
    shape.dart           # PuzzleNode, PuzzleLine, PuzzleShape definitions
  screens/
    game_screen.dart     # Main gameplay screen with board, overlays, and number bar
    home_screen.dart     # Level select screen listing all available shapes
  theme/
    app_theme.dart       # Colour scheme, text theme, and button styles
  widgets/
    number_bar.dart      # Persistent bottom bar (number grid, hint, undo, erase, how-to-play toggle)
    puzzle_board_painter.dart  # CustomPainter rendering lines, stubs, and product labels
  main.dart              # App entry point
test/
  puzzle_test.dart       # Unit tests for the solver and generator
```

---

## Tech Stack

| Concern | Choice |
|---|---|
| Language | Dart |
| Framework | Flutter 3.x |
| Fonts | google_fonts |
| Animations | flutter_animate |
| Persistence | shared_preferences |
| Target | Android (iOS planned) |

---

## How the Generator Works

1. A random permutation of 1..N is assigned to the shape's N circles.
2. Line products are computed from the assignment.
3. The backtracking solver verifies the puzzle has exactly one solution. If not, a new permutation is tried.
4. Difficulty is rated by the ratio of constraint lines to circles and the size of the number range.
5. Label positions (which end of each line shows the clue) are randomised with a spread rule: the end with fewer existing labels is preferred, breaking ties randomly.

---

## Puzzle Shapes

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Tutorial | 3 | 3 | Simple triangle, always easy |
| Grid | 8 | 5 | Square grid with diagonals through a central hub |
| Triangle | 7 | 6 | Layered triangle with shared interior nodes |
| L-Shape | 5 | 4 | Asymmetric L arrangement |

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK (for Android builds)

### Run in development

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Build release APK

```bash
flutter build apk --release
```

---

## Roadmap

- iOS build and App Store submission
- Additional hand-designed shapes
- Persistent progress and level tracking via shared_preferences
- Sound effects and haptic feedback
- Leaderboard / personal best times
- Shape editor tool for designing new puzzles visually

---

## License

This project is private and not yet licensed for redistribution.
