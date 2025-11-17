import 'package:flutter/material.dart';

class GameEndOverlay extends StatelessWidget {
  final String title;
  final Color titleColor;
  final int score;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  const GameEndOverlay({
    super.key,
    required this.title,
    required this.titleColor,
    required this.score,
    required this.onRestart,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 400),
      child: Container(
        color: Colors.black87.withOpacity(0.85),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 48,
                color: titleColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 10),
                ]
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GameButton(
                    label: "Restart",
                    color: Colors.greenAccent,
                    onTap: onRestart,
                ),
                const SizedBox(width: 20,),
                _GameButton(
                  label: "Menu",
                  color: Colors.blueGrey,
                  onTap: onMenu,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GameButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
