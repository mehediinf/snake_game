import 'package:flutter/material.dart';

class DPadControls extends StatelessWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const DPadControls({
    super.key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DBtn(icon: Icons.keyboard_arrow_up_rounded, onTap: onUp),
              const SizedBox(height: 8),
              Row(
                children: [
                  _DBtn(icon: Icons.keyboard_arrow_left_rounded, onTap: onLeft),
                  const SizedBox(width: 8),
                  _buildCenter(),
                  const SizedBox(width: 8),
                  _DBtn(
                      icon: Icons.keyboard_arrow_right_rounded, onTap: onRight),
                ],
              ),
              const SizedBox(height: 8),
              _DBtn(icon: Icons.keyboard_arrow_down_rounded, onTap: onDown),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCenter() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E3B),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF2ECC71).withOpacity(0.2),
        ),
      ),
      child: const Center(
        child: Text('🐍', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _DBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DBtn({required this.icon, required this.onTap});

  @override
  State<_DBtn> createState() => _DBtnState();
}

class _DBtnState extends State<_DBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onTap();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _pressed
              ? const Color(0xFF2ECC71).withOpacity(0.3)
              : const Color(0xFF1A2E3B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _pressed
                ? const Color(0xFF2ECC71)
                : const Color(0xFF2ECC71).withOpacity(0.3),
            width: _pressed ? 2 : 1,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF2ECC71).withOpacity(0.3),
                    blurRadius: 10,
                  )
                ]
              : [],
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? const Color(0xFF2ECC71) : const Color(0xFF7F8C8D),
          size: 28,
        ),
      ),
    );
  }
}
