import 'package:fake_async/fake_async.dart';
import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:fallingfusion/logic/controllers/game_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GameController spawns a falling block after first tick', () {
    fakeAsync((async) {
      final controller = GameController();
      async.elapse(const Duration(milliseconds: 0));
      async.elapse(const Duration(milliseconds: 500));
      expect(controller.state.fallingBlock, isNotNull);
      controller.stopGame();
    });
  });

  test('Falling block moves down on ticks and locks on collision', () {
    fakeAsync((async) {
      final controller = GameController();
      async.elapse(const Duration(milliseconds: 500));
      final falling = controller.state.fallingBlock!;
      final startY = falling.position.y;

      async.elapse(const Duration(milliseconds: 500));
      expect(controller.state.fallingBlock!.position.y, startY + 1);

      final underPos = Position(falling.position.x, falling.position.y + 1);
      final stationary = Block(value: falling.value, position: underPos, type: BlockType.normal);
      controller.state = controller.state.copyWith(blocks: [stationary], fallingBlock:
        controller.state.fallingBlock);

      async.elapse(const Duration(milliseconds: 500));
      expect(controller.state.fallingBlock, isNotNull, reason: 'Controller spawns a new falling block after locking');

      controller.stopGame();
    });
  });

  test('Blocks merge when equal and adjacent vertically', () {
    fakeAsync((async) {
      final controller = GameController();

      final stationary = Block(value: 2, position: const Position(2, 4), type: BlockType.normal);
      controller.state = controller.state.copyWith(blocks: [stationary], fallingBlock: null);

      controller.state = controller.state.copyWith(
        fallingBlock: Block(value: 2, position: const Position(2, 0), type: BlockType.normal),
      );

      async.elapse(const Duration(milliseconds: 500 * 10));

      async.flushMicrotasks();

      final vals = controller.state.blocks.map((b) => b.value).toList();
      expect(vals.contains(4), true);
      controller.stopGame();
    });
  });

  test('Bomb removes nearby blocks and adds score', () {
    fakeAsync((async) {
      final controller = GameController();

      final center = Block(value: 2, position: const Position(2, 3), type: BlockType.normal);
      final neighbor1 = Block(value: 4, position: const Position(1, 3), type: BlockType.normal);
      final neighbor2 = Block(value: 8, position: const Position(3, 3), type: BlockType.normal);

      controller.state = controller.state.copyWith(blocks: [center, neighbor1, neighbor2], fallingBlock: null);

      final bomb = Block(value: 0, position: const Position(2, 3), type: BlockType.bombSmall);
      controller.state = controller.state.copyWith(fallingBlock: bomb);

      final below = Block(value: 2, position: const Position(2, 4), type: BlockType.normal);
      controller.state = controller.state.copyWith(blocks: [center, neighbor1, neighbor2, below]);

      async.elapse(const Duration(milliseconds: 500));

      final remainingVals = controller.state.blocks.map((b) => b.value).toList();

      expect(remainingVals.contains(2), false);
      expect(remainingVals.contains(4), false);
      expect(remainingVals.contains(8), false);


      expect(controller.state.score >= 14, true);
      controller.stopGame();
    });
  });
}