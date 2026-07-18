import 'package:flutter/foundation.dart';
import 'puzzle.dart';

enum GameStatus { playing, solved, checking }

class GameState extends ChangeNotifier {
  final Puzzle puzzle;

  /// Current player-entered values: nodeId → value (null = empty).
  final Map<int, int?> _board = {};

  /// Undo history: list of (nodeId, previousValue).
  final List<(int, int?)> _history = [];

  /// Currently selected circle (null = nothing selected).
  int? selectedNodeId;

  /// How many hints the player has left.
  int hintsRemaining = 3;

  GameStatus _status = GameStatus.playing;

  /// Nodes highlighted as wrong after a Check.
  final Set<int> _wrongNodes = {};

  GameState(this.puzzle) {
    for (final node in puzzle.shape.nodes) {
      _board[node.id] = null;
    }
  }

  GameStatus get status => _status;
  Set<int> get wrongNodes => Set.unmodifiable(_wrongNodes);

  int? valueAt(int nodeId) => _board[nodeId];

  bool get isBoardFull => _board.values.every((v) => v != null);

  // ── Selection ────────────────────────────────────────────────────────────

  void selectNode(int nodeId) {
    if (_status == GameStatus.solved) return;
    selectedNodeId = selectedNodeId == nodeId ? null : nodeId;
    _wrongNodes.clear();
    if (_status == GameStatus.checking) _status = GameStatus.playing;
    notifyListeners();
  }

  // ── Placing & erasing ────────────────────────────────────────────────────

  void placeValue(int nodeId, int value) {
    if (_status == GameStatus.solved) return;
    _history.add((nodeId, _board[nodeId]));
    _board[nodeId] = value;
    _wrongNodes.clear();
    if (_status == GameStatus.checking) _status = GameStatus.playing;
    notifyListeners();
  }

  void placeValueAtSelected(int value) {
    if (selectedNodeId == null) return;
    placeValue(selectedNodeId!, value);
  }

  void clearValue(int nodeId) {
    if (_status == GameStatus.solved) return;
    _history.add((nodeId, _board[nodeId]));
    _board[nodeId] = null;
    _wrongNodes.clear();
    if (_status == GameStatus.checking) _status = GameStatus.playing;
    notifyListeners();
  }

  void eraseSelected() {
    if (selectedNodeId == null) return;
    clearValue(selectedNodeId!);
  }

  // ── Undo ─────────────────────────────────────────────────────────────────

  bool get canUndo => _history.isNotEmpty;

  void undo() {
    if (_history.isEmpty) return;
    final (nodeId, prev) = _history.removeLast();
    _board[nodeId] = prev;
    _wrongNodes.clear();
    if (_status == GameStatus.checking) _status = GameStatus.playing;
    notifyListeners();
  }

  // ── Hint ─────────────────────────────────────────────────────────────────

  bool get hasHints => hintsRemaining > 0;

  /// Reveals the correct value for one wrong or empty circle.
  /// Selects that circle so the player sees what changed.
  void useHint() {
    if (!hasHints || _status == GameStatus.solved) return;

    final candidates = puzzle.shape.nodes
        .where((n) => _board[n.id] != puzzle.solution[n.id])
        .toList()
      ..shuffle();

    if (candidates.isEmpty) return;

    final node = candidates.first;
    _history.add((node.id, _board[node.id]));
    _board[node.id] = puzzle.solution[node.id];
    selectedNodeId = node.id;
    hintsRemaining--;
    _wrongNodes.clear();
    if (_status == GameStatus.checking) _status = GameStatus.playing;
    notifyListeners();
  }

  // ── Check & solve ─────────────────────────────────────────────────────────

  bool checkSolution() {
    _wrongNodes.clear();
    bool allCorrect = true;

    for (final node in puzzle.shape.nodes) {
      final placed = _board[node.id];
      if (placed == null || placed != puzzle.solution[node.id]) {
        _wrongNodes.add(node.id);
        allCorrect = false;
      }
    }

    if (allCorrect) {
      _status = GameStatus.solved;
      selectedNodeId = null;
    } else {
      _status = GameStatus.checking;
    }

    notifyListeners();
    return allCorrect;
  }

  Map<int, bool> get lineStatuses {
    final result = <int, bool>{};
    for (int i = 0; i < puzzle.shape.lines.length; i++) {
      final line = puzzle.shape.lines[i];
      int product = 1;
      bool complete = true;
      for (final nodeId in line.nodeIds) {
        final v = _board[nodeId];
        if (v == null) {
          complete = false;
          break;
        }
        product *= v;
      }
      result[i] = complete && product == puzzle.lineProducts[i];
    }
    return result;
  }

  void reset() {
    for (final key in _board.keys) {
      _board[key] = null;
    }
    _history.clear();
    _wrongNodes.clear();
    selectedNodeId = null;
    hintsRemaining = 3;
    _status = GameStatus.playing;
    notifyListeners();
  }

  Set<int> get usedValues => _board.values.whereType<int>().toSet();
}
