import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/logic/providers/game_provider.dart';
import 'package:fallingfusion/ui/widgets/board_grid.dart';
import 'package:fallingfusion/ui/widgets/bomb_button.dart';
import 'package:fallingfusion/ui/widgets/control_button.dart';
import 'package:fallingfusion/ui/widgets/score_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ScorePanel(score: gameState.score),

            Expanded(
              child: Center(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      controller.moveRight();
                    } else {
                      controller.moveLeft();
                    }
                  },
                  child: BoardGrid(
                    blocks: gameState.blocks,
                    fallingBlock: gameState.fallingBlock,
                  ),
                ),
              ),
            ),

            const ControlButtons(),

            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BombButton(
                      label: "Small bomb",
                      color: Colors.orangeAccent,
                      onTap: () => controller.activateBombMode(BlockType.bombSmall),
                    ),
                    const SizedBox(width: 12,),
                    BombButton(
                      label: "Large bomb",
                      color: Colors.redAccent,
                      onTap: () => controller.activateBombMode(BlockType.bombLarge),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
