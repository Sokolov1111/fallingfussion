import 'package:fallingfusion/core/constants/app_colors.dart';
import 'package:fallingfusion/core/constants/app_text_styles.dart';
import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final color = switch (block.type) {
      BlockType.normal => AppColors.numberColor(block.value),
      BlockType.bombSmall => Colors.orangeAccent,
      BlockType.bombLarge => Colors.redAccent,
    };

    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ]
      ),
      child: Text(
        block.type == BlockType.normal ? '${block.value}' :  '💣',
        style: AppTextStyles.blockNumber,
      ),
    );
  }
}
