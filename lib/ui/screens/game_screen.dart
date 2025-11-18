import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/logic/providers/game_provider.dart';
import 'package:fallingfusion/ui/screens/main_menu_screen.dart';
import 'package:fallingfusion/ui/widgets/board_grid.dart';
import 'package:fallingfusion/ui/widgets/bomb_cooldown_button.dart';
import 'package:fallingfusion/ui/widgets/control_button.dart';
import 'package:fallingfusion/ui/widgets/game_end_overlay.dart';
import 'package:fallingfusion/ui/widgets/score_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameControllerProvider.notifier).restartGame();
    });
  }

  void _confirmExitToMenu(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);

    if (!controller.isPaused) {
      controller.togglePause();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white70,
        title: const Text(
          'Exit to Main Menu',
          style: TextStyle(color: Colors.black54),
        ),
        content: const Text(
          "Are you sure you want to return to the main menu?",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.togglePause();
            },
            child: const Text("No", style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              final controller = ref.read(gameControllerProvider.notifier);
              controller.stopGame();

              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainMenuScreen()),
              );
            },
            child: const Text("Yes", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _confirmExitToMenu(context, ref),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[700],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Menu",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      ScorePanel(score: gameState.score),
                    ],
                  ),
                ),

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
                      BombCooldownButton(
                        label: "Small bomb",
                        color: Colors.orangeAccent,
                        onReadyTap: () =>
                            controller.useBomb(BlockType.bombSmall),
                        progress: controller.bombChargeProgress,
                        isReady: controller.isBombReady,
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: controller.togglePause,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            color: controller.isPaused
                                ? Colors.greenAccent.withOpacity(0.8)
                                : Colors.grey[700],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            controller.isPaused ? "Resume" : "Pause",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      BombCooldownButton(
                        label: "Large bomb",
                        color: Colors.redAccent,
                        onReadyTap: () =>
                            controller.useBomb(BlockType.bombLarge),
                        progress: controller.bombChargeProgress,
                        isReady: controller.isBombReady,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (controller.countdown > 0)
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Text(
                    "${controller.countdown}",
                    style: const TextStyle(
                      fontSize: 120,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                ),
              ),

            if (gameState.isGameOver)
              GameEndOverlay(
                title: "Game Over",
                titleColor: Colors.redAccent,
                score: gameState.score,
                onRestart: controller.restartGame,
                onMenu: () {
                  final controller = ref.read(gameControllerProvider.notifier);
                  controller.stopGame();

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                  );
                },
              ),

            if (gameState.isVictory)
              GameEndOverlay(
                title: "VICTORY!",
                titleColor: Colors.amberAccent,
                score: gameState.score,
                onRestart: controller.restartGame,
                onMenu: () {
                  final controller = ref.read(gameControllerProvider.notifier);
                  controller.stopGame();

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainMenuScreen()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
