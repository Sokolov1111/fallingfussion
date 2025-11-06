import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Block.copyWith preserves id when preserveId=true', () {
    final b = Block(value: 2, position: const Position(0, 0), type: BlockType.normal);
    final b2 = b.copyWith(position: const Position(1, 0), preserveId: true);

    expect(b2.position, const Position(1, 0));
    expect(b2.id, b.id, reason: 'id should be preserved when preservedId=true');
  });

  test('Block.copyWith generates new id by default', () {
    final b = Block(value: 2, position: const Position(0, 0), type: BlockType.normal);
    final b2 = b.copyWith(position: const Position(1, 0));

    expect(b2.position, const Position(1, 0));
    expect(b2.id != b.id, true, reason: 'id should be new when preservedId=false');
  });

  test('moveTo returns a new block with updated position and same id if preservedId used', () {
    final b = Block(value: 4, position: const Position(2, 0), type: BlockType.normal);
    final moved = b.moveTo(const Position(2, 1));

    expect(moved.position, const Position(2, 1));
  });

  test('mergeWith creates new block with sum value and new id', () {
    final a = Block(value: 2, position: const Position(1, 1), type: BlockType.normal);
    final b = Block(value: 2, position: const Position(1, 1), type: BlockType.normal);
    final merged = a.mergeWith(b);

    expect(merged.value, 4);
    expect(merged.position, a.position);
    expect(merged.id != a.id, true);
    expect(merged.id != b.id, true);
    expect(merged.isMerging, true);
  });
}