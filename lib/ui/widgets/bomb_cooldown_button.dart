import 'package:flutter/material.dart';

class BombCooldownButton extends StatelessWidget {
  final String label;
  final Color color;
  final double progress;
  final bool isReady;
  final VoidCallback onReadyTap;

  const BombCooldownButton({
    super.key,
    required this.label,
    required this.color,
    required this.onReadyTap,
    required this.progress,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isReady ? onReadyTap : null,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              color: isReady
                  ? color.withOpacity(1.0)
                  : color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6),
              boxShadow: isReady
                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                shadows: isReady
                    ? [Shadow(color: Colors.black26, blurRadius: 4)]
                    : [],
              ),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 120,
            height: 50 * progress,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}