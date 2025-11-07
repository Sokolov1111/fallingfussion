
import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/game_state.dart';
import 'package:fallingfusion/logic/controllers/game_controller.dart';
import 'package:fallingfusion/logic/providers/game_provider.dart';
import 'package:fallingfusion/ui/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TestGameController extends GameController {
  bool bombActivated = false;
  BlockType? lastType;

  TestGameController() : super();

  @override
  void activateBombMode(BlockType type) {
    bombActivated = true;
    lastType = type;
  }
}

void main() {
  testWidgets('GameScreen renders and bomb button triggers controller', (tester) async {
    final testController = TestGameController();

    testController.stopGame();

    final providerOverride = StateNotifierProvider<GameController, GameState>(
        (ref) => testController,
    );

    await tester.pumpWidget(
      ProviderScope(
          overrides: [
            gameControllerProvider.overrideWithProvider(providerOverride),
          ],
          child: const MaterialApp(home: GameScreen(),),
      ),
    );

    await tester.pumpAndSettle();

    final smallBombFinder = find.text('Small bomb');
    expect(smallBombFinder, findsOneWidget);

    await tester.tap(smallBombFinder);
    await tester.pump();

    expect(testController.bombActivated, isTrue);
    expect(testController.lastType, BlockType.bombSmall);
  });
}