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
- 19 hand-designed puzzle shapes across 5 shape families with natural difficulty progression
- Difficulty rating (Easy / Medium / Hard) computed from constraint density
- Randomised clue label placement — the tip of a line can appear on either end, spread intelligently to avoid visual crowding
- Correct stub rendering: stub direction always follows the **local segment angle** at each line endpoint, not the overall first-to-last direction
- Persistent number bar with Hint, Undo, and Erase actions
- Auto-check: the puzzle automatically validates when all circles are filled
- Scan-and-glow solve animation on correct completion
- Inline error banner (appears below the difficulty badge, never covers the number bar)
- Collapsible "How to play" panel that slides over the puzzle without shifting the layout
- Tap anywhere outside the panel to dismiss it
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

Shapes are organised into families. Each family shares the same node layout; variants differ only in how many lines are active, giving a natural easy-to-hard progression within the family.

### 3-Node Triangle Family

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| V Shape | 3 | 2 | Open V, two edges only |
| Tutorial | 3 | 3 | Full triangle, always easy — good for new players |

### 4-Node Square Family

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Arc | 4 | 3 | Three sides of the square (open bottom) |
| Square | 4 | 4 | Full perimeter |
| Square X | 4 | 5 | Perimeter + one diagonal |
| Square XX | 4 | 6 | Perimeter + both diagonals |

### 5-Node Center-Square Family

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Kite | 5 | 4 | Asymmetric: three sides + one diagonal through center |
| Diamond | 5 | 4 | Symmetric: top + bottom + both diagonals through center |
| Star | 5 | 5 | Perimeter + one diagonal through center |
| Star X | 5 | 6 | Perimeter + both diagonals through center |

### 7-Node Triangle Family

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Triangle | 7 | 4 | Outer edges + middle row (center vertical removed) |
| Big Triangle | 7 | 5 | Outer edges + middle row + center vertical |

### 8-Node Grid Family

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Grid Open | 8 | 4 | Columns and rows only, no diagonals |
| Grid Light | 8 | 5 | Columns + rows + one diagonal |
| Grid | 8 | 6 | Columns + rows + both diagonals |

### 8-Node Hourglass Family

Node layout: two top corners + hub (top-center offset) + two mid-level side nodes + three bottom nodes.
The X diagonals cross at the hub: top-left→hub→mid-right and top-right→hub→mid-left.

| Shape | Circles | Lines | Notes |
|---|---|---|---|
| Hourglass Light | 8 | 5 | Columns + bottom row + X diagonals |
| Hourglass | 8 | 6 | Hourglass Light + middle horizontal (mid-left × mid-right) |
| Hourglass Plus | 8 | 7 | Hourglass + center vertical (hub × bottom-center) |

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
- Persistent progress and level tracking via shared_preferences
- Sound effects and haptic feedback
- Leaderboard / personal best times
- Shape editor tool for designing new puzzles visually

---

## License

This project is private and not yet licensed for redistribution.
