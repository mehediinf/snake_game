import 'dart:math';

enum Direction { up, down, left, right }

enum GameState { idle, playing, paused, gameOver }

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Position && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  Position copyWith({int? x, int? y}) => Position(x ?? this.x, y ?? this.y);
}

class FoodItem {
  final Position position;
  final String emoji;
  final int points;

  const FoodItem({
    required this.position,
    required this.emoji,
    required this.points,
  });
}

class SnakeModel {
  static const List<Map<String, dynamic>> foodTypes = [
    {'emoji': '🍎', 'points': 10},
    {'emoji': '🍊', 'points': 10},
    {'emoji': '🍇', 'points': 15},
    {'emoji': '🍓', 'points': 15},
    {'emoji': '🌟', 'points': 30},
  ];

  static FoodItem generateFood(int gridSize, List<Position> snake) {
    final rand = Random();
    Position pos;
    do {
      pos = Position(rand.nextInt(gridSize), rand.nextInt(gridSize));
    } while (snake.contains(pos));

    final food = foodTypes[rand.nextInt(foodTypes.length)];
    return FoodItem(
      position: pos,
      emoji: food['emoji'] as String,
      points: food['points'] as int,
    );
  }
}
