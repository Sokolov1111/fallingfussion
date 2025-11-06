import 'package:flutter/material.dart';

class BombButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const BombButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
    );
  }
}
