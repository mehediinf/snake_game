import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/snake_model.dart';

class GameController extends ChangeNotifier {
  static const int _gridSizeValue = 20;

  List<Position> _snake = [];
  FoodItem? _food;
  Direction _direction = Direction.right;
  Direction _nextDirection = Direction.right;
  GameState _gameState = GameState.idle;
  int _score = 0;
  int _highScore = 0;
  int _level = 1;
  int _speed = 1; // 1=slow, 2=medium, 3=fast
  Timer? _gameTimer;
  int _foodEaten = 0;
  String _currentPlayer = 'Muaz';

  List<Position> get snake => _snake;
  FoodItem? get food => _food;
  Direction get direction => _direction;
  GameState get gameState => _gameState;
  int get score => _score;
  int get highScore => _highScore;
  int get level => _level;
  int get speed => _speed;
  int get gridSize => _gridSizeValue;
  String get currentPlayer => _currentPlayer;

  GameController() {
    _loadHighScore();
  }

  void setPlayer(String name) {
    _currentPlayer = name;
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('snake_high_score_$_currentPlayer') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('snake_high_score_$_currentPlayer', _highScore);
    }
  }

  void setSpeed(int speed) {
    _speed = speed;
    notifyListeners();
  }

  void startGame() {
    _gameTimer?.cancel();
    _score = 0;
    _foodEaten = 0;
    _level = 1;
    _direction = Direction.right;
    _nextDirection = Direction.right;
    _gameState = GameState.playing;

    // Init snake in the middle
    final mid = gridSize ~/ 2;
    _snake = [
      Position(mid, mid),
      Position(mid - 1, mid),
      Position(mid - 2, mid),
    ];

    _food = SnakeModel.generateFood(gridSize, _snake);
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    // Speed: 1=300ms, 2=200ms, 3=120ms
    final intervals = {1: 300, 2: 200, 3: 120};
    final interval = intervals[_speed] ?? 200;

    _gameTimer = Timer.periodic(Duration(milliseconds: interval), (_) {
      _tick();
    });
  }

  void changeDirection(Direction newDir) {
    // Prevent reversing
    if (newDir == Direction.up && _direction == Direction.down) return;
    if (newDir == Direction.down && _direction == Direction.up) return;
    if (newDir == Direction.left && _direction == Direction.right) return;
    if (newDir == Direction.right && _direction == Direction.left) return;
    _nextDirection = newDir;
  }

  void togglePause() {
    if (_gameState == GameState.playing) {
      _gameState = GameState.paused;
      _gameTimer?.cancel();
    } else if (_gameState == GameState.paused) {
      _gameState = GameState.playing;
      _startTimer();
    }
    notifyListeners();
  }

  void _tick() {
    if (_gameState != GameState.playing) return;

    _direction = _nextDirection;

    final head = _snake.first;
    Position newHead;

    switch (_direction) {
      case Direction.up:
        newHead = Position(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Position(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Position(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Position(head.x + 1, head.y);
        break;
    }

    // Wall collision
    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize) {
      _endGame();
      return;
    }

    // Self collision (skip tail since it will move)
    if (_snake.sublist(0, _snake.length - 1).contains(newHead)) {
      _endGame();
      return;
    }

    _snake.insert(0, newHead);

    // Check food
    if (_food != null && newHead == _food!.position) {
      _score += _food!.points * _level;
      _foodEaten++;
      _food = SnakeModel.generateFood(gridSize, _snake);

      // Level up every 5 food
      if (_foodEaten % 5 == 0) {
        _level++;
      }
    } else {
      _snake.removeLast();
    }

    notifyListeners();
  }

  void _endGame() {
    _gameTimer?.cancel();
    _gameState = GameState.gameOver;
    _saveHighScore();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
