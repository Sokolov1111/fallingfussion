import 'dart:math';
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
    final paddingHorizontal = 16.0 * 2;
    final maxWidth = MediaQuery.of(context).size.width - paddingHorizontal;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final cellWidth = maxWidth / GameConfig.columns;
    final cellHeight = maxHeight / GameConfig.rows;
    final cellSize = min(cellWidth, cellHeight);

    final allBlocks = [...blocks];
    if (fallingBlock != null) allBlocks.add(fallingBlock!);
    if (allBlocks.map((b) => b.id).toSet().length != allBlocks.length) {
      debugPrint('⚠️ Duplicate block IDs detected: ${allBlocks.map((b) => b.id)}');
    }

    return Container(
      width: GameConfig.columns * cellSize,
      height: GameConfig.rows * cellSize,
      decoration: BoxDecoration(
        color: AppColors.boardBackground,
        border: Border.all(color: AppColors.boardBorder, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        key: ValueKey(allBlocks.length),
        children: [
          for (final block in allBlocks)
            Positioned(
              key: ValueKey('${block.id}_${block.isMerging}'),
              top: block.position.y * cellSize,
              left: block.position.x * cellSize,
              child: BlockWidget(block: block, cellSize: cellSize,),
            ),
        ],
      ),
    );
  }
}