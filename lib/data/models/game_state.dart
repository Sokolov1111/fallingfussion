import 'package:fallingfusion/data/models/block.dart';
import 'package:flutter/foundation.dart';

@immutable
class GameState {
  final List<Block> blocks;
  final Block? fallingBlock;
  final int score;
  final bool isGameOver;
  final bool isVictory;
  final int level;

  const GameState({
    required this.blocks,
    this.fallingBlock,
    this.score = 0,
    this.isGameOver = false,
    this.isVictory = false,
    this.level = 1,
  });

  factory GameState.initial() => const GameState(blocks: []);

  GameState copyWith({
    List<Block>? blocks,
    Block? fallingBlock,
    int? score,
    bool? isGameOver,
    bool? isVictory,
    int? level,
  }) {
    return GameState(
        blocks: blocks ?? this.blocks,
        fallingBlock: fallingBlock ?? this.fallingBlock,
        score: score ?? this.score,
        isGameOver: isGameOver ?? this.isGameOver,
        isVictory: isVictory ?? this.isVictory,
        level: level ?? this.level,
    );
  }

  @override
  String toString() =>
      'GameState(blocks:${blocks.length}, score:$score, level:$level, gameOver:$isGameOver';
}
