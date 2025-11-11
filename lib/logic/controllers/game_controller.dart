import 'dart:async';
import 'dart:math';

import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/data/models/game_state.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GameController extends StateNotifier<GameState> {
  GameController() : super(GameState.initial()) {
    _startGameLoop();
  }

  final int columns = 5;
  final int rows = 8;
  final Duration tickDuration = const Duration(milliseconds: 500);

  Timer? _timer;

  bool bombMode = false;
  BlockType selectedBombType = BlockType.bombSmall;

  DateTime? _lastMoveTime;
  final Duration moveCooldown = const Duration(milliseconds: 200);

  void _startGameLoop() {
    _timer = Timer.periodic(tickDuration, (_) {
      if (!state.isGameOver) {
        _dropTick();
      }
    });
  }

  void stopGame() {
    _timer?.cancel();
  }

  void _spawnNewBlock() {
    final randomValue = pow(2, [1, 1, 2, 2, 3, 3, 4, 4][Random().nextInt(8)]).toInt();

    Block newBlock;

    if (bombMode) {
      newBlock = Block(
          value: randomValue,
          position: Position(columns ~/ 2, 0),
          type: selectedBombType,
      );
      bombMode = false;
    } else {
      newBlock = Block(
          value: randomValue,
          position: Position(columns ~/ 2, 0),
          type: BlockType.normal,
      );
    }

    state = state.copyWith(fallingBlock: newBlock);
  }

  void _dropTick() {
    final falling = state.fallingBlock;

    if (falling == null) {
      _spawnNewBlock();
      return;
    }

    final nextPos = falling.position.below();

    if (_isCollision(nextPos)) {
      _lockFallingBlock(falling);
    } else {
      state = state.copyWith(
        fallingBlock: falling.copyWith(
          position: nextPos,
          preserveId: true,
        ),
      );
    }
  }

  bool _isCollision(Position pos) {
    if (pos.y >= rows) return true;

    for (final b in state.blocks) {
      if (b.position == pos) return true;
    }

    return false;
  }

  void _lockFallingBlock(Block block) {
    state = state.copyWith(fallingBlock: null);

    Future.microtask(() {
      final updatedBlocks = List<Block>.from(state.blocks)..add(block);

      if (block.type != BlockType.normal) {
        _activateBomb(block, updatedBlocks);
      } else {
        state = state.copyWith(
          blocks: updatedBlocks,
        );
      }

      _mergeBlocks();
      _checkGameOver();
      _spawnNewBlock();
    });
  }

  void _mergeBlocks() {
    bool didMerge = false;
    final blocks = List<Block>.from(state.blocks);

    blocks.sort((a, b) => b.position.y.compareTo(a.position.y));

    for (int i = 0; i < blocks.length; i++) {
      for (int j = i + 1; j < blocks.length; j++) {
        final a = blocks[i];
        final b = blocks[j];

        final isSameColumn = a.position.x == b.position.x;
        final isAdjacentVertically =
            (a.position.y - b.position.y).abs() == 1;

        if (isSameColumn &&
            isAdjacentVertically &&
            a.value == b.value &&
            a.type == BlockType.normal &&
            b.type == BlockType.normal) {
          final merged = a.copyWith(
            value: a.value * 2,
            preserveId: false,
            isMerging: true,
          );

          blocks.remove(a);
          blocks.remove(b);
          blocks.add(merged);

          state = state.copyWith(score: state.score + merged.value);

          didMerge = true;
          break;
        }
      }
      if (didMerge) break;
    }

    state = state.copyWith(blocks: blocks);

    if (didMerge) {

      Future.delayed(const Duration(milliseconds: 300), () {
        final reset = state.blocks
            .map((b) => b.isMerging ? b.copyWith(isMerging: false) : b)
            .toList();
        state = state.copyWith(blocks: reset);
      });
      _mergeBlocks();
    } else {
      state = state.copyWith(blocks: blocks);
    }
  }
  
  void _activateBomb(Block bomb, List<Block> blockList) {
    final radius = bomb.type == BlockType.bombSmall ? 1 : 2;
    
    final remainingBlocks = blockList.where((b) => !bomb.position.isNeighborOf(b.position, radius: radius)).toList();
    final explodedBlocks = blockList.where((b) => bomb.position.isNeighborOf(b.position, radius: radius)).toList();

    final scoreGained = explodedBlocks.fold<int>(0, (sum, b) => sum + b.value);

    state = state.copyWith(
      blocks: remainingBlocks,
      score: state.score + scoreGained,
    );
  }

  void moveLeft() {
    final now = DateTime.now();
    if (_lastMoveTime != null && now.difference(_lastMoveTime!) < moveCooldown) {
      return;
    }
    _lastMoveTime = now;

    final falling = state.fallingBlock;
    if (falling == null) return;

    final newPos = Position(max(0, falling.position.x - 1), falling.position.y);
    if (!_isCollision(newPos)) {
      state = state.copyWith(
        fallingBlock: falling.copyWith(position: newPos, preserveId: true)
      );
    }
  }

  void moveRight() {
    final now = DateTime.now();
    if (_lastMoveTime != null && now.difference(_lastMoveTime!) < moveCooldown) {
      return;
    }
    _lastMoveTime = now;
    final falling = state.fallingBlock;
    if (falling == null) return;

    final newPos = Position(min(columns - 1, falling.position.x + 1), falling.position.y);
    if (!_isCollision(newPos)) {
      state = state.copyWith(
        fallingBlock: falling.copyWith(position: newPos, preserveId: true)
      );
    }
  }

  void dropFaster() {
    final falling = state.fallingBlock;
    if (falling == null) return;

    Position nextPos = falling.position;
    while (!_isCollision(nextPos.below())) {
      nextPos = nextPos.below();
    }

    state = state.copyWith(
      fallingBlock: falling.copyWith(position: nextPos, preserveId: true),
    );

    _lockFallingBlock(state.fallingBlock!);
  }

  void activateBombMode(BlockType type) {
    bombMode = true;
    selectedBombType = type;
  }

  void _checkGameOver() {
    for (final block in state.blocks) {
      if (block.position.y == 0) {
        stopGame();
        state = state.copyWith(isGameOver: true, fallingBlock: null);
        return;
      }
    }
  }

}