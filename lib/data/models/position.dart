import 'package:flutter/foundation.dart';

@immutable
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  Position below() => Position(x, y + 1);

  bool isNeighborOf(Position other, {int radius = 1}) {
    return (x - other.x).abs() <= radius && (y - other.y).abs() <= radius;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';

}