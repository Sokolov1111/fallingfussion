import 'package:flutter/material.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/core/enums/block_type.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final double cellSize;

  const BlockWidget({super.key, required this.block, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = _getBlockColor(block.value, block.type);
    final isTripleMerge = block.value % 8 == 0;

    return AnimatedScale(
      scale: block.isMerging ? 1.5 : 1.0,
      duration: Duration(milliseconds: isTripleMerge ? 500 : 300),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        width: cellSize,
        height: cellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: block.isMerging
              ? (isTripleMerge ? Colors.purpleAccent : Colors.amberAccent)
              : baseColor,
          borderRadius: BorderRadius.circular(cellSize * 0.18),
          boxShadow: [
            if (block.isMerging)
              BoxShadow(
                color: isTripleMerge
                    ? Colors.deepPurple.withOpacity(0.8)
                    : Colors.yellowAccent.withOpacity(0.7),
                blurRadius: cellSize * 0.3,
                spreadRadius: cellSize * 0.06,
              ),
            if (block.isFastDropping)
              BoxShadow(
                color: baseColor.withOpacity(0.7),
                blurRadius: cellSize * 0.6,
                spreadRadius: cellSize * 0.18,
                offset: Offset(
                  0,
                  cellSize * 0.25,
                ),
              ),
          ],
        ),
        child: Center(
          child: Text(
            block.type == BlockType.normal ? block.value.toString() : '💣',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: cellSize * 0.4,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.3), blurRadius: cellSize * 0.06),
              ],
            ),
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
