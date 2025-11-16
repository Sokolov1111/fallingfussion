import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'position.dart';
import 'package:fallingfusion/core/enums/block_type.dart';

@immutable
class Block {
  final String id;
  final int value;
  final Position position;
  final BlockType type;
  final bool isMerging;
  final bool isFastDropping;

  Block({
    String? id,
    required this.value,
    required this.position,
    required this.type,
    this.isMerging = false,
    this.isFastDropping = false,
  }) : id = id ?? const Uuid().v4();

  Block moveTo(Position newPosition) {
    return copyWith(position: newPosition);
  }

  Block mergeWith(Block other) {
    return Block(
      id: const Uuid().v4(),
      value: value + other.value,
      position: position,
      type: type,
      isMerging: true,
    );
  }

  Block copyWith({
    String? id,
    int? value,
    Position? position,
    BlockType? type,
    bool? isMerging,
    bool? isFastDropping,
    bool preserveId = false,
  }) {
    return Block(
      id: preserveId ? (id ?? this.id) : const Uuid().v4(),
      value: value ?? this.value,
      position: position ?? this.position,
      type: type ?? this.type,
      isMerging: isMerging ?? this.isMerging,
      isFastDropping: isFastDropping ?? this.isFastDropping,
    );
  }

  @override
  String toString() =>
      'Block(id: $id, value: $value, pos: ${position.x},${position.y}, type: $type)';
}