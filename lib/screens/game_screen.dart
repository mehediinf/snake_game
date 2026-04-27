import 'package:flutter/material.dart';
import '../utils/game_controller.dart';
import '../models/snake_model.dart';
import '../widgets/game_board.dart';
import '../widgets/dpad_controls.dart';
import '../widgets/game_over_overlay.dart';

class GameScreen extends StatefulWidget {
  final int speed;
  final String playerName;

  const GameScreen({
    super.key,
    required this.speed,
    required this.playerName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = GameController();
    _ctrl.setPlayer(widget.playerName);
    _ctrl.setSpeed(widget.speed);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.startGame();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleSwipe(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final dy = details.delta.dy;
    if (dx.abs() > dy.abs()) {
      if (dx > 0) _ctrl.changeDirection(Direction.right);
      else _ctrl.changeDirection(Direction.left);
    } else {
      if (dy > 0) _ctrl.changeDirection(Direction.down);
      else _ctrl.changeDirection(Direction.up);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _ctrl,
          builder: (ctx, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 8),
                    // Game Board with swipe
                    GestureDetector(
                      onPanUpdate: _ctrl.gameState == GameState.playing
                          ? _handleSwipe
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GameBoard(controller: _ctrl),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // D-Pad controls
                    DPadControls(
                      onUp: () => _ctrl.changeDirection(Direction.up),
                      onDown: () => _ctrl.changeDirection(Direction.down),
                      onLeft: () => _ctrl.changeDirection(Direction.left),
                      onRight: () => _ctrl.changeDirection(Direction.right),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

                // Game Over / Pause Overlay
                if (_ctrl.gameState == GameState.gameOver)
                  GameOverOverlay(
                    playerName: widget.playerName,
                    score: _ctrl.score,
                    highScore: _ctrl.highScore,
                    snakeLength: _ctrl.snake.length,
                    onReplay: () => _ctrl.startGame(),
                    onHome: () => Navigator.pop(context),
                  ),

                if (_ctrl.gameState == GameState.paused)
                  _buildPauseOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2E3B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.home_rounded,
                  color: Color(0xFF2ECC71), size: 22),
            ),
          ),

          const Spacer(),

          // Player & Score
          Column(
            children: [
              Text(widget.playerName.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF2ECC71),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2)),
              Text(
                '${_ctrl.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 24),

          // Level
          Column(
            children: [
              const Text('LEVEL',
                  style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 12)),
              Text(
                '${_ctrl.level}',
                style: const TextStyle(
                  color: Color(0xFFF1C40F),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Pause
          GestureDetector(
            onTap: _ctrl.gameState == GameState.gameOver
                ? null
                : _ctrl.togglePause,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2E3B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _ctrl.gameState == GameState.paused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                color: const Color(0xFF2ECC71),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⏸️', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            const Text(
              'PAUSED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _ctrl.togglePause,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '▶  CONTINUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
