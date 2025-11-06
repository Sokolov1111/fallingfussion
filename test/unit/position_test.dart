
import 'package:fallingfusion/data/models/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Position.below increase y by 1', () {
    final p = const Position(2, 3);
    final below = p.below();

    expect(below, const Position(2, 4));
  });

  test('isNeighborOf detects neighbors within radius', () {
    final p = const Position(3, 3);

    expect(p.isNeighborOf(const Position(3, 4)), true);
    expect(p.isNeighborOf(const Position(4, 4)), true);
    expect(p.isNeighborOf(const Position(5, 5)), false);
    expect(p.isNeighborOf(const Position(5, 5), radius: 2), true);
  });

  test('Position equality and hashCode works', () {
    final a = const Position(1, 2);
    final b = const Position(1, 2);

    expect(a == b, true);
    expect(a.hashCode, b.hashCode);
  });
}