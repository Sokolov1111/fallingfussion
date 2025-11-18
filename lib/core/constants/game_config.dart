import 'dart:math';
import 'package:flutter/cupertino.dart';

class GameConfig {
  static const int columns = 5;
  static const int rows = 8;

  static double calculateCellSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final availableWidth = size.width;
    final availableHeight = size.height - padding.top - padding.bottom - 100;

    final maxCellWidth = availableWidth / columns;
    final maxCellHeight = availableHeight / rows;

    return min(maxCellWidth, maxCellHeight).floorToDouble();
  }

  static double boardWidth(double cellSize) => cellSize * columns;
  static double boardHeight(double cellSize) => cellSize * rows;
}