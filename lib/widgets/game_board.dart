import 'package:flutter/material.dart';
import '../utils/game_controller.dart';
import '../models/snake_model.dart';

class GameBoard extends StatelessWidget {
  final GameController controller;

  const GameBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 24;
    final cellSize = screenWidth / controller.gridSize;

    return Container(
      width: screenWidth,
      height: screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _BoardPainter(
            snake: controller.snake,
            food: controller.food,
            gridSize: controller.gridSize,
            cellSize: cellSize,
            direction: controller.direction,
          ),
          size: Size(screenWidth, screenWidth),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final List<Position> snake;
  final FoodItem? food;
  final int gridSize;
  final double cellSize;
  final Direction direction;

  _BoardPainter({
    required this.snake,
    required this.food,
    required this.gridSize,
    required this.cellSize,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawSnake(canvas);
    _drawFood(canvas);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2E3B).withOpacity(0.4)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= gridSize; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        paint,
      );
    }
  }

  void _drawSnake(Canvas canvas) {
    if (snake.isEmpty) return;

    for (int i = 0; i < snake.length; i++) {
      final pos = snake[i];
      final isHead = i == 0;
      final isTail = i == snake.length - 1;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          pos.x * cellSize + 1,
          pos.y * cellSize + 1,
          cellSize - 2,
          cellSize - 2,
        ),
        Radius.circular(isHead || isTail ? cellSize * 0.4 : cellSize * 0.2),
      );

      // Gradient color: head bright green → tail darker
      final t = snake.length > 1 ? i / (snake.length - 1) : 0.0;
      final color = Color.lerp(
        const Color(0xFF2ECC71),
        const Color(0xFF1A5C35),
        t,
      )!;

      final paint = Paint()..color = color;
      canvas.drawRRect(rect, paint);

      // Head details - eyes
      if (isHead) {
        _drawEyes(canvas, pos);
      }
    }
  }

  void _drawEyes(Canvas canvas, Position head) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;

    final cx = head.x * cellSize + cellSize / 2;
    final cy = head.y * cellSize + cellSize / 2;
    final eyeSize = cellSize * 0.12;
    final eyeOffset = cellSize * 0.2;

    Offset eye1, eye2;

    switch (direction) {
      case Direction.right:
        eye1 = Offset(cx + eyeOffset, cy - eyeOffset);
        eye2 = Offset(cx + eyeOffset, cy + eyeOffset);
        break;
      case Direction.left:
        eye1 = Offset(cx - eyeOffset, cy - eyeOffset);
        eye2 = Offset(cx - eyeOffset, cy + eyeOffset);
        break;
      case Direction.up:
        eye1 = Offset(cx - eyeOffset, cy - eyeOffset);
        eye2 = Offset(cx + eyeOffset, cy - eyeOffset);
        break;
      case Direction.down:
        eye1 = Offset(cx - eyeOffset, cy + eyeOffset);
        eye2 = Offset(cx + eyeOffset, cy + eyeOffset);
        break;
    }

    canvas.drawCircle(eye1, eyeSize, eyePaint);
    canvas.drawCircle(eye2, eyeSize, eyePaint);
    canvas.drawCircle(eye1, eyeSize * 0.55, pupilPaint);
    canvas.drawCircle(eye2, eyeSize * 0.55, pupilPaint);
  }

  void _drawFood(Canvas canvas) {
    if (food == null) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: food!.emoji,
        style: TextStyle(fontSize: cellSize * 0.7),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      food!.position.x * cellSize + (cellSize - textPainter.width) / 2,
      food!.position.y * cellSize + (cellSize - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_BoardPainter old) => true;
}
