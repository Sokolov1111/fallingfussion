import 'package:fallingfusion/core/constants/game_config.dart';
import 'package:flutter/material.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/core/enums/block_type.dart';

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final double size = GameConfig.cellSize;
    final Color baseColor = _getBlockColor(block.value, block.type);

    return AnimatedScale(
      scale: block.isMerging ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: block.isMerging
              ? baseColor.withOpacity(0.9)
              : baseColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          boxShadow: block.isMerging
              ? [
            BoxShadow(
              color: Colors.yellowAccent.withOpacity(0.7),
              blurRadius: 16,
              spreadRadius: 4,
            )
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Text(
          block.value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBlockColor(int value, BlockType type) {
    if (type == BlockType.bombSmall) return Colors.orangeAccent;
    if (type == BlockType.bombLarge) return Colors.redAccent;

    switch (value) {
      case 2:
        return Colors.blueGrey.shade400;
      case 4:
        return Colors.lightBlue.shade400;
      case 8:
        return Colors.cyan.shade400;
      case 16:
        return Colors.teal.shade400;
      case 32:
        return Colors.green.shade500;
      case 64:
        return Colors.yellow.shade700;
      case 128:
        return Colors.orange.shade700;
      case 256:
        return Colors.deepOrange.shade600;
      case 512:
        return Colors.pink.shade600;
      case 1024:
        return Colors.purple.shade600;
      case 2048:
        return Colors.indigo.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
