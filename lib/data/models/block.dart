import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:flutter/foundation.dart';

@immutable
class Block {
  final int id;
  final int value;
  final Position position;
  final BlockType type;
  final bool isMerging;
  final bool isExploding;

  const Block({
    required this.id,
    required this.value,
    required this.position,
    this.type = BlockType.normal,
    this.isMerging = false,
    this.isExploding = false,
  });

  Block moveTo(Position newPos) => copyWith(position: newPos);

  Block mergeWith(Block other) {
    assert(position == other.position, 'Merge only allowed on same position');
    return copyWith(
      value: value + other.value,
      isMerging: true,
    );
  }

  Block copyWith({
    int? id,
    int? value,
    Position? position,
    BlockType? type,
    bool? isMerging,
    bool? isExploding,
  }) {
    return Block(
        id: id ?? this.id,
        value: value ?? this.value,
        position: position ?? this.position,
        type: type ?? this.type,
        isMerging: isMerging ?? false,
        isExploding: isExploding ?? false,
    );
  }

  @override
  String toString() =>
      'Block(id:$id, val: $value, pos:$position, type:$type, merging:$isMerging';
}