import '../models/shape.dart';

/// All shapes use an abstract 0.0–4.0 coordinate grid scaled at render time.
/// Shapes are grouped into families that share the same node layout but differ
/// only in how many lines connect those nodes.

// ─────────────────────────────────────────────────────────────────────────────
// 3-NODE TRIANGLE FAMILY
// ─────────────────────────────────────────────────────────────────────────────

/// 3 circles, 2 lines — open V shape (one edge removed from Tutorial).
///
///   1(2,0)
///   |      \
///   0(0,2)  2(2,2) -- (no top-right edge)
const shapeV3 = PuzzleShape(
  id: 'v_3',
  name: 'V Shape',
  circleCount: 3,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 2.0),
    PuzzleNode(id: 1, x: 2.0, y: 0.0),
    PuzzleNode(id: 2, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([0, 1]),
    PuzzleLine([0, 2]),
  ],
);

/// 3 circles, 3 lines — full triangle, all pairs connected.
const shapeTriangle3 = PuzzleShape(
  id: 'triangle_3',
  name: 'Tutorial',
  circleCount: 3,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 2.0),
    PuzzleNode(id: 1, x: 2.0, y: 0.0),
    PuzzleNode(id: 2, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([0, 1]),
    PuzzleLine([1, 2]),
    PuzzleLine([0, 2]),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 4-NODE SQUARE FAMILY
// ─────────────────────────────────────────────────────────────────────────────

/// 4 circles, 3 lines — three sides of the square (open at bottom).
///
///   0(0,0) ── 1(4,0)
///     |              |
///   3(0,4)        2(4,4)
const shapeArc4 = PuzzleShape(
  id: 'arc_4',
  name: 'Arc',
  circleCount: 4,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([0, 1]), // top
    PuzzleLine([1, 2]), // right
    PuzzleLine([3, 0]), // left
  ],
);

/// 4 circles, 4 lines — full perimeter.
///
///   0(0,0) ── 1(4,0)
///     |              |
///   3(0,4) ── 2(4,4)
const shapeSquare4 = PuzzleShape(
  id: 'square_4',
  name: 'Square',
  circleCount: 4,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([0, 1]), // top
    PuzzleLine([1, 2]), // right
    PuzzleLine([2, 3]), // bottom
    PuzzleLine([3, 0]), // left
  ],
);

/// 4 circles, 5 lines — perimeter + 1 diagonal.
///
///   0(0,0) ── 1(4,0)
///     |    ╲        |
///   3(0,4) ── 2(4,4)
const shapeSquare5 = PuzzleShape(
  id: 'square_5',
  name: 'Square X',
  circleCount: 4,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([0, 1]), // top
    PuzzleLine([1, 2]), // right
    PuzzleLine([2, 3]), // bottom
    PuzzleLine([3, 0]), // left
    PuzzleLine([0, 2]), // diagonal TL→BR
  ],
);

/// 4 circles, 6 lines — perimeter + both diagonals (all possible pairs).
///
///   0(0,0) ── 1(4,0)
///     |    ╲ ╱    |
///     |    ╱ ╲    |
///   3(0,4) ── 2(4,4)
const shapeSquare6 = PuzzleShape(
  id: 'square_6',
  name: 'Square XX',
  circleCount: 4,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([0, 1]), // top
    PuzzleLine([1, 2]), // right
    PuzzleLine([2, 3]), // bottom
    PuzzleLine([3, 0]), // left
    PuzzleLine([0, 2]), // diagonal TL→BR
    PuzzleLine([1, 3]), // diagonal TR→BL
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 5-NODE CENTER-SQUARE FAMILY
// ─────────────────────────────────────────────────────────────────────────────

/// 5 circles, 4 lines — asymmetric (from the book): 3 sides + 1 diagonal through center.
///
///   0(0,0) ── 1(4,0)
///     |    ╲
///     |      4(2,2)
///     |              ╲
///   3(0,4) ── 2(4,4)
const shapeKite5 = PuzzleShape(
  id: 'kite_5',
  name: 'Kite',
  circleCount: 5,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // center
  ],
  lines: [
    PuzzleLine([0, 1]),    // top
    PuzzleLine([3, 0]),    // left
    PuzzleLine([3, 2]),    // bottom
    PuzzleLine([0, 4, 2]), // diagonal TL→BR through center
  ],
);

/// 5 circles, 4 lines — symmetric: top + bottom + both diagonals through center.
///
///   0(0,0)   1(4,0)
///      ╲       ╱
///        4(2,2)
///      ╱       ╲
///   3(0,4)   2(4,4)
const shapeL5 = PuzzleShape(
  id: 'l_5',
  name: 'Diamond',
  circleCount: 5,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // center
  ],
  lines: [
    PuzzleLine([0, 1]),    // top
    PuzzleLine([2, 3]),    // bottom
    PuzzleLine([0, 4, 2]), // diagonal TL→BR through center
    PuzzleLine([1, 4, 3]), // diagonal TR→BL through center
  ],
);

/// 5 circles, 5 lines — perimeter + 1 diagonal through center.
///
///   0(0,0) ── 1(4,0)
///     |    ╲        |
///     |      4(2,2)  |
///     |              |
///   3(0,4) ── 2(4,4)
const shapeCenterSquare5 = PuzzleShape(
  id: 'center_square_5',
  name: 'Star',
  circleCount: 5,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // center
  ],
  lines: [
    PuzzleLine([0, 1]),    // top
    PuzzleLine([1, 2]),    // right
    PuzzleLine([2, 3]),    // bottom
    PuzzleLine([3, 0]),    // left
    PuzzleLine([0, 4, 2]), // diagonal TL→BR through center
  ],
);

/// 5 circles, 6 lines — perimeter + both diagonals through center.
///
///   0(0,0) ── 1(4,0)
///     |    ╲ ╱    |
///     |      4(2,2)|
///     |    ╱ ╲    |
///   3(0,4) ── 2(4,4)
const shapeCenterSquare6 = PuzzleShape(
  id: 'center_square_6',
  name: 'Star X',
  circleCount: 5,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 4.0, y: 0.0),
    PuzzleNode(id: 2, x: 4.0, y: 4.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // center
  ],
  lines: [
    PuzzleLine([0, 1]),    // top
    PuzzleLine([1, 2]),    // right
    PuzzleLine([2, 3]),    // bottom
    PuzzleLine([3, 0]),    // left
    PuzzleLine([0, 4, 2]), // diagonal TL→BR through center
    PuzzleLine([1, 4, 3]), // diagonal TR→BL through center
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 7-NODE TRIANGLE FAMILY
// ─────────────────────────────────────────────────────────────────────────────
//
//            5(2,0)
//          3(1,2)  4(2,2)  2(3,2)
//       0(0,4)      6(2,4)      1(4,4)

/// 7 circles, 4 lines — outer edges + middle horizontal (center vertical removed).
const shapeTriangle7_4 = PuzzleShape(
  id: 'triangle_7_4',
  name: 'Triangle',
  circleCount: 7,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 4.0),
    PuzzleNode(id: 1, x: 4.0, y: 4.0),
    PuzzleNode(id: 2, x: 3.0, y: 2.0),
    PuzzleNode(id: 3, x: 1.0, y: 2.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0),
    PuzzleNode(id: 5, x: 2.0, y: 0.0),
    PuzzleNode(id: 6, x: 2.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([5, 3, 0]), // left edge
    PuzzleLine([5, 2, 1]), // right edge
    PuzzleLine([0, 6, 1]), // bottom edge
    PuzzleLine([3, 4, 2]), // middle horizontal
  ],
);

/// 7 circles, 5 lines — outer edges + middle horizontal + center vertical.
const shapeTriangle7 = PuzzleShape(
  id: 'triangle_7',
  name: 'Big Triangle',
  circleCount: 7,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 4.0),
    PuzzleNode(id: 1, x: 4.0, y: 4.0),
    PuzzleNode(id: 2, x: 3.0, y: 2.0),
    PuzzleNode(id: 3, x: 1.0, y: 2.0),
    PuzzleNode(id: 4, x: 2.0, y: 2.0),
    PuzzleNode(id: 5, x: 2.0, y: 0.0),
    PuzzleNode(id: 6, x: 2.0, y: 4.0),
  ],
  lines: [
    PuzzleLine([5, 3, 0]), // left edge
    PuzzleLine([5, 2, 1]), // right edge
    PuzzleLine([0, 6, 1]), // bottom edge
    PuzzleLine([3, 4, 2]), // middle horizontal
    PuzzleLine([5, 4, 6]), // center vertical
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 8-NODE GRID FAMILY
// ─────────────────────────────────────────────────────────────────────────────
//
//   0(0,0)          2(4,0)
//        \          /
//   1(0,2) -- 7(2,2) -- 4(4,2)
//        /          \
//   3(0,4) -- 6(2,4) -- 5(4,4)

/// 8 circles, 4 lines — columns + rows only, both diagonals removed.
const shapeGrid8_4 = PuzzleShape(
  id: 'grid_8_4',
  name: 'Grid Open',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 0.0, y: 2.0),
    PuzzleNode(id: 2, x: 4.0, y: 0.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 4.0, y: 2.0),
    PuzzleNode(id: 5, x: 4.0, y: 4.0),
    PuzzleNode(id: 6, x: 2.0, y: 4.0),
    PuzzleNode(id: 7, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([1, 7, 4]), // middle row
  ],
);

/// 8 circles, 5 lines — columns + rows + 1 diagonal.
const shapeGrid8_5 = PuzzleShape(
  id: 'grid_8_5',
  name: 'Grid Light',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 0.0, y: 2.0),
    PuzzleNode(id: 2, x: 4.0, y: 0.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 4.0, y: 2.0),
    PuzzleNode(id: 5, x: 4.0, y: 4.0),
    PuzzleNode(id: 6, x: 2.0, y: 4.0),
    PuzzleNode(id: 7, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([2, 7, 3]), // diagonal TR→BL
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([1, 7, 4]), // middle row
  ],
);

/// 8 circles, 6 lines — columns + rows + both diagonals.
const shapeGrid8 = PuzzleShape(
  id: 'grid_8',
  name: 'Grid',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0),
    PuzzleNode(id: 1, x: 0.0, y: 2.0),
    PuzzleNode(id: 2, x: 4.0, y: 0.0),
    PuzzleNode(id: 3, x: 0.0, y: 4.0),
    PuzzleNode(id: 4, x: 4.0, y: 2.0),
    PuzzleNode(id: 5, x: 4.0, y: 4.0),
    PuzzleNode(id: 6, x: 2.0, y: 4.0),
    PuzzleNode(id: 7, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([0, 7, 5]), // diagonal TL→BR
    PuzzleLine([2, 7, 3]), // diagonal TR→BL
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([1, 7, 4]), // middle row
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 8-NODE HOURGLASS FAMILY
// ─────────────────────────────────────────────────────────────────────────────
//
//   0(0,0)      7(2,1)      2(4,0)
//   1(0,2)                  4(4,2)
//   3(0,4) -- 6(2,4) -- 5(4,4)

/// 8 circles, 5 lines — columns + bottom row + X diagonals through hub.
/// Visually the cross forms an X: top-left→hub→mid-right and top-right→hub→mid-left.
const shapeHourglass8_4 = PuzzleShape(
  id: 'hourglass_8_4',
  name: 'Hourglass Light',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0), // top-left
    PuzzleNode(id: 1, x: 0.0, y: 2.0), // mid-left
    PuzzleNode(id: 2, x: 4.0, y: 0.0), // top-right
    PuzzleNode(id: 3, x: 0.0, y: 4.0), // bottom-left
    PuzzleNode(id: 4, x: 4.0, y: 2.0), // mid-right
    PuzzleNode(id: 5, x: 4.0, y: 4.0), // bottom-right
    PuzzleNode(id: 6, x: 2.0, y: 4.0), // bottom-center
    PuzzleNode(id: 7, x: 2.0, y: 1.0), // hub
  ],
  lines: [
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([0, 7, 4]), // X diagonal: top-left × hub × mid-right
    PuzzleLine([2, 7, 1]), // X diagonal: top-right × hub × mid-left
  ],
);

/// 8 circles, 6 lines — Hourglass + middle horizontal through mid-left and mid-right.
const shapeHourglassGrid8 = PuzzleShape(
  id: 'hourglass_grid_8',
  name: 'Hourglass',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0), // top-left
    PuzzleNode(id: 1, x: 0.0, y: 2.0), // mid-left
    PuzzleNode(id: 2, x: 4.0, y: 0.0), // top-right
    PuzzleNode(id: 3, x: 0.0, y: 4.0), // bottom-left
    PuzzleNode(id: 4, x: 4.0, y: 2.0), // mid-right
    PuzzleNode(id: 5, x: 4.0, y: 4.0), // bottom-right
    PuzzleNode(id: 6, x: 2.0, y: 4.0), // bottom-center
    PuzzleNode(id: 7, x: 2.0, y: 1.0), // hub
  ],
  lines: [
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([0, 7, 4]), // X diagonal: top-left × hub × mid-right
    PuzzleLine([2, 7, 1]), // X diagonal: top-right × hub × mid-left
    PuzzleLine([1, 4]),    // middle horizontal: mid-left × mid-right
  ],
);

/// 8 circles, 7 lines — Hourglass + center vertical from hub to bottom-center.
const shapeHourglassPlus8 = PuzzleShape(
  id: 'hourglass_plus_8',
  name: 'Hourglass Plus',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0), // top-left
    PuzzleNode(id: 1, x: 0.0, y: 2.0), // mid-left
    PuzzleNode(id: 2, x: 4.0, y: 0.0), // top-right
    PuzzleNode(id: 3, x: 0.0, y: 4.0), // bottom-left
    PuzzleNode(id: 4, x: 4.0, y: 2.0), // mid-right
    PuzzleNode(id: 5, x: 4.0, y: 4.0), // bottom-right
    PuzzleNode(id: 6, x: 2.0, y: 4.0), // bottom-center
    PuzzleNode(id: 7, x: 2.0, y: 1.0), // hub
  ],
  lines: [
    PuzzleLine([0, 1, 3]), // left column
    PuzzleLine([2, 4, 5]), // right column
    PuzzleLine([3, 6, 5]), // bottom row
    PuzzleLine([0, 7, 4]), // X diagonal: top-left × hub × mid-right
    PuzzleLine([2, 7, 1]), // X diagonal: top-right × hub × mid-left
    PuzzleLine([1, 4]),    // middle horizontal: mid-left × mid-right
    PuzzleLine([7, 6]),    // center vertical: hub × bottom-center
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// All shapes ordered by family and ascending line count
// ─────────────────────────────────────────────────────────────────────────────

const List<PuzzleShape> allShapes = [
  // 3-node triangle family
  shapeV3,
  shapeTriangle3,
  // 4-node square family
  shapeArc4,
  shapeSquare4,
  shapeSquare5,
  shapeSquare6,
  // 5-node center-square family
  shapeKite5,
  shapeL5,
  shapeCenterSquare5,
  shapeCenterSquare6,
  // 7-node triangle family
  shapeTriangle7_4,
  shapeTriangle7,
  // 8-node grid family
  shapeGrid8_4,
  shapeGrid8_5,
  shapeGrid8,
  // 8-node hourglass family
  shapeHourglass8_4,
  shapeHourglassGrid8,
  shapeHourglassPlus8,
];
