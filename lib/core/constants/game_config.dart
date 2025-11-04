
class GameConfig {
  static const double cellSize = 48.0;
  static const int columns = 5;
  static const int rows = 8;

  static double get boardWidth => cellSize * columns;
  static double get boardHeight => cellSize * rows;
}