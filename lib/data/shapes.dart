import '../models/shape.dart';

/// All hand-designed shapes extracted from the book examples.
/// Node coordinates use an abstract grid (0.0–4.0 range), scaled at render time.

/// Image 1 (example page): 3 circles in a triangle.
/// Lines: each pair of circles shares a line.
///   Node 0 (left), Node 1 (top-right), Node 2 (bottom-right)
const shapeTriangle3 = PuzzleShape(
  id: 'triangle_3',
  name: 'Tutorial',
  circleCount: 3,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 1.0),
    PuzzleNode(id: 1, x: 2.0, y: 0.0),
    PuzzleNode(id: 2, x: 2.0, y: 2.0),
  ],
  lines: [
    PuzzleLine([0, 1]),
    PuzzleLine([1, 2]),
    PuzzleLine([0, 2]),
  ],
);

/// Image 2: 8 circles in a square-grid with an X through the center (circle 8).
///
///   1 (0,0)          3 (4,0)
///       \            /
///        \          /
///   2 (0,2)  --8(2,2)--  5(4,2)
///        /          \
///       /            \
///   4 (0,4)  --7(2,4)--  6(4,4)
///
/// Lines:
///   Diagonal TL→BR : [0, 7, 5]  (nodes 1,8,6 in book)
///   Diagonal TR→BL : [2, 7, 3]  (nodes 3,8,4 in book)
///   Left column    : [0, 1, 3]  (nodes 1,2,4)
///   Right column   : [2, 4, 5]  (nodes 3,5,6)
///   Bottom row     : [3, 6, 5]  (nodes 4,7,6)
///   Middle row     : [1, 7, 4]  (nodes 2,8,5)
const shapeGrid8 = PuzzleShape(
  id: 'grid_8',
  name: 'Grid',
  circleCount: 8,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0), // book circle 1
    PuzzleNode(id: 1, x: 0.0, y: 2.0), // book circle 2
    PuzzleNode(id: 2, x: 4.0, y: 0.0), // book circle 3
    PuzzleNode(id: 3, x: 0.0, y: 4.0), // book circle 4
    PuzzleNode(id: 4, x: 4.0, y: 2.0), // book circle 5
    PuzzleNode(id: 5, x: 4.0, y: 4.0), // book circle 6
    PuzzleNode(id: 6, x: 2.0, y: 4.0), // book circle 7
    PuzzleNode(id: 7, x: 2.0, y: 2.0), // book circle 8 (center)
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

/// Image 3: 7 circles in a triangle pyramid.
///
///            6 (2,0)
///          4(1,1) 5(2,1) 3(3,1)
///       1(0,2)    7(2,2)    2(4,2)
///
/// Lines:
///   Left edge   : [5, 3, 0]  (nodes 6,4,1)
///   Right edge  : [5, 2, 1]  (nodes 6,3,2)
///   Bottom edge : [0, 6, 1]  (nodes 1,7,2)
///   Middle row  : [3, 4, 2]  (nodes 4,5,3)
///   Center vert : [5, 4, 6]  (nodes 6,5,7)
const shapeTriangle7 = PuzzleShape(
  id: 'triangle_7',
  name: 'Big Triangle',
  circleCount: 7,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 4.0), // book circle 1 (bottom-left)
    PuzzleNode(id: 1, x: 4.0, y: 4.0), // book circle 2 (bottom-right)
    PuzzleNode(id: 2, x: 3.0, y: 2.0), // book circle 3 (mid-right)
    PuzzleNode(id: 3, x: 1.0, y: 2.0), // book circle 4 (mid-left)
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // book circle 5 (mid-center)
    PuzzleNode(id: 5, x: 2.0, y: 0.0), // book circle 6 (top)
    PuzzleNode(id: 6, x: 2.0, y: 4.0), // book circle 7 (bottom-center)
  ],
  lines: [
    PuzzleLine([5, 3, 0]), // left edge
    PuzzleLine([5, 2, 1]), // right edge
    PuzzleLine([0, 6, 1]), // bottom edge
    PuzzleLine([3, 4, 2]), // middle horizontal
    PuzzleLine([5, 4, 6]), // center vertical
  ],
);

/// Image 4: 5 circles in an L/diagonal shape.
///
///   3(0,0)  ----  5(2,0)
///   |      \
///   |       4(1,1)
///   |              \
///   2(0,2)  ----  1(2,2)
///
/// Lines:
///   Top horizontal  : [0, 1]     (nodes 3,5)
///   Left vertical   : [0, 3]     (nodes 3,2)
///   Diagonal TL→BR  : [0, 2, 4]  (nodes 3,4,1)
///   Bottom horizontal: [3, 4]    (nodes 2,1)
const shapeL5 = PuzzleShape(
  id: 'l_5',
  name: 'Diamond',
  circleCount: 5,
  nodes: [
    PuzzleNode(id: 0, x: 0.0, y: 0.0), // book circle 3 (top-left)
    PuzzleNode(id: 1, x: 2.0, y: 0.0), // book circle 5 (top-right)
    PuzzleNode(id: 2, x: 1.0, y: 1.0), // book circle 4 (center)
    PuzzleNode(id: 3, x: 0.0, y: 2.0), // book circle 2 (bottom-left)
    PuzzleNode(id: 4, x: 2.0, y: 2.0), // book circle 1 (bottom-right)
  ],
  lines: [
    PuzzleLine([0, 1]),    // top horizontal
    PuzzleLine([0, 3]),    // left vertical
    PuzzleLine([0, 2, 4]), // main diagonal
    PuzzleLine([3, 4]),    // bottom horizontal
  ],
);

/// All available shapes in the order they unlock.
const List<PuzzleShape> allShapes = [
  shapeTriangle3,
  shapeL5,
  shapeTriangle7,
  shapeGrid8,
];
