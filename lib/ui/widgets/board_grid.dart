import 'package:fallingfusion/core/constants/app_colors.dart';
import 'package:fallingfusion/core/constants/game_config.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/ui/widgets/block_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardGrid extends ConsumerWidget {
  final List<Block> blocks;
  final Block? fallingBlock;

  const BoardGrid({
    super.key,
    required this.blocks,
    required this.fallingBlock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBlocks = [...blocks];
    if (fallingBlock != null) allBlocks.add(fallingBlock!);
    if (allBlocks.map((b) => b.id).toSet().length != allBlocks.length) {
      debugPrint('⚠️ Duplicate block IDs detected: ${allBlocks.map((b) => b.id)}');
    }

    return Container(
      width: GameConfig.boardWidth,
      height: GameConfig.boardHeight,
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        border: Border.all(color: AppColors.boardBorder, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        key: ValueKey(allBlocks.length),
        children: [
          for (final block in allBlocks)
            Positioned(
              key: ValueKey(block.id),
              top: block.position.y * GameConfig.cellSize,
              left: block.position.x * GameConfig.cellSize,
              child: BlockWidget(block: block),
            ),
        ],
      ),
    );
  }
}