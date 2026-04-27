import 'package:flutter/material.dart';
import '../utils/game_controller.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  int _selectedSpeed = 1;
  String _selectedPlayer = 'Muaz';
  final _controller = GameController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnim = Tween(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _controller.setPlayer(_selectedPlayer);
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onPlayerChanged(String name) {
    setState(() {
      _selectedPlayer = name;
    });
    _controller.setPlayer(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Animated Snake Emoji
                ScaleTransition(
                  scale: _scaleAnim,
                  child: const Text('🐍', style: TextStyle(fontSize: 90)),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'SNAKE GAME',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2ECC71),
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Color(0xFF27AE60),
                        blurRadius: 20,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'High Quality Classic',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7F8C8D),
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 32),

                // Player Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SELECT PLAYER',
                    style: TextStyle(
                      color: Color(0xFFECF0F1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPlayerBtn('Muaz', '👦'),
                    const SizedBox(width: 12),
                    _buildPlayerBtn('Navan', '🧒'),
                  ],
                ),

                const SizedBox(height: 24),

                // High Score Card
                _buildHighScoreCard(),

                const SizedBox(height: 24),

                // Speed Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SELECT SPEED',
                    style: TextStyle(
                      color: Color(0xFFECF0F1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSpeedBtn(1, '🐢 Slow', const Color(0xFF27AE60)),
                    const SizedBox(width: 10),
                    _buildSpeedBtn(2, '🐇 Medium', const Color(0xFFF39C12)),
                    const SizedBox(width: 10),
                    _buildSpeedBtn(3, '⚡ Fast', const Color(0xFFE74C3C)),
                  ],
                ),

                const SizedBox(height: 40),

                // Play Button
                GestureDetector(
                  onTap: _startGame,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2ECC71).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'START GAME',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerBtn(String name, String emoji) {
    final isSelected = _selectedPlayer == name;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onPlayerChanged(name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2ECC71).withOpacity(0.15) : const Color(0xFF1A2E3B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF2ECC71) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E3B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BEST FOR $_selectedPlayer',
                style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 13),
              ),
              ListenableBuilder(
                listenable: _controller,
                builder: (ctx, _) => Text(
                  '${_controller.highScore}',
                  style: const TextStyle(
                    color: Color(0xFFF1C40F),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedBtn(int speed, String label, Color color) {
    final selected = _selectedSpeed == speed;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSpeed = speed),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.2) : const Color(0xFF1A2E3B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : color.withOpacity(0.2),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label.split(' ')[0],
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                label.split(' ')[1],
                style: TextStyle(
                  color: selected ? color : const Color(0xFF7F8C8D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => GameScreen(
          speed: _selectedSpeed,
          playerName: _selectedPlayer,
        ),
        transitionsBuilder: (ctx, anim, _, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
    );
    // Refresh the high score when coming back from the game
    _controller.setPlayer(_selectedPlayer);
  }
}
