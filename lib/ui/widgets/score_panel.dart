import 'package:flutter/material.dart';

class ScorePanel extends StatelessWidget {
  final int score;

  const ScorePanel({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
