import 'dart:async';
import 'dart:math';

import 'package:fallingfusion/core/constants/game_config.dart';
import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/data/models/game_state.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameController extends StateNotifier<GameState> {
  GameController() : super(GameState.initial()) {
    restartGame(withCountdown: false);
  }

  final int columns = 5;
  final int rows = 8;

  bool isFastDropping = false;
  final Duration normalTick = const Duration(milliseconds: 500);
  final Duration fastTick = const Duration(milliseconds: 50);

  Duration get tickDuration => isFastDropping ? fastTick : normalTick;

  static const Duration bombCooldown = Duration(minutes: 1);
  DateTime _bombCooldownStart = DateTime.now();
  Timer? _bombCooldownTimer;
  double _bombChargeProgress = 0.0;
  bool get isBombReady => _bombChargeProgress >= 1.0;
  double get bombChargeProgress => _bombChargeProgress;

  Timer? _timer;

  bool bombMode = false;
  BlockType selectedBombType = BlockType.bombSmall;

  DateTime? _lastMoveTime;
  final Duration moveCooldown = const Duration(milliseconds: 200);

  bool isPaused = false;
  int countdown = 0;
  Timer? _countdownTimer;

  void _startGameLoop() {
    _timer?.cancel();
    _timer = Timer.periodic(tickDuration, (_) {
      if (!state.isGameOver && !isPaused) {
        _dropTick();
      }
    });
  }

  void _restartGameLoopWithNewSpeed() {
    _timer?.cancel();
    _timer = Timer.periodic(
        tickDuration,
        (_) {
          if (!state.isGameOver && !isPaused) {
            _dropTick();
          }
        }
    );
  }

  void setFastDrop(bool enable) {
    if (enable == isFastDropping) return;

    isFastDropping = enable;

    _restartGameLoopWithNewSpeed();

    final falling = state.fallingBlock;
    if (falling != null) {
      state = state.copyWith(
        fallingBlock: falling.copyWith(
          isFastDropping: enable,
          preserveId: true,
        )
      );
    }
  }

  void stopGame() {
    _timer?.cancel();
    _bombCooldownTimer?.cancel();
    _countdownTimer?.cancel();
  }

  void restartGame({bool withCountdown = true}) {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _countdownTimer?.cancel();

    isPaused = false;
    isFastDropping = false;
    countdown = 0;
    _bombChargeProgress = 0.0;
    bombMode = false;
    selectedBombType = BlockType.bombSmall;
    _lastMoveTime = null;

    state = GameState.initial();

    _startBombCooldownTimer();

    if (withCountdown) {
      _startCountdown(isResume: false);
    } else {
      isPaused = false;
      _startGameLoop();
    }
  }

  void togglePause() {
    if (!isPaused) {
      isPaused = true;
      stopGame();
      state = state.copyWith();
    } else {
      _startCountdown(isResume: true);
    }
  }

  void _startCountdown({bool isResume = false}) {
    if (!isResume) {
      isPaused = true;
    }

    countdown = 3;
    state = state.copyWith();

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown--;
      state = state.copyWith();

      if (countdown <= 0) {
        timer.cancel();
        countdown = 0;

        isPaused = false;

        _startGameLoop();
        state = state.copyWith();
      }
    });
  }

  void _spawnNewBlock() {
    final randomValue = pow(
      2,
      [1, 1, 2, 2, 3, 3, 4, 4][Random().nextInt(8)],
    ).toInt();

    Block newBlock;

    newBlock = Block(
      value: randomValue,
      position: Position(columns ~/ 2, 0),
      type: bombMode ? selectedBombType : BlockType.normal,
      isFastDropping: isFastDropping,
    );

    bombMode = false;
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
        fallingBlock: falling.copyWith(position: nextPos, preserveId: true),
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
    final blockToAdd = block.copyWith(isFastDropping: false, preserveId: true);
    state = state.copyWith(fallingBlock: null);

    Future.microtask(() {
      final updatedBlocks = List<Block>.from(state.blocks)..add(blockToAdd);

      if (blockToAdd.type != BlockType.normal) {
        _activateBomb(blockToAdd, updatedBlocks);
      } else {
        state = state.copyWith(blocks: updatedBlocks);
      }

      _mergeBlocks();
      _checkGameOver();
      _spawnNewBlock();
    });
  }

  void _mergeBlocks() {
    bool didMerge = false;
    final blocks = List<Block>.from(state.blocks);

    for (int y = 0; y < GameConfig.rows; y++) {
      final rowBlocks = blocks.where((b) => b.position.y == y).toList()
        ..sort((a, b) => a.position.x.compareTo(b.position.x));

      for (int i = 0; i < rowBlocks.length - 2; i++) {
        final a = rowBlocks[i];
        final b = rowBlocks[i + 1];
        final c = rowBlocks[i + 2];

        final isConsecutive =
            (b.position.x == a.position.x + 1) &&
            (c.position.x == b.position.x + 1);
        final isSameValue = a.value == b.value && b.value == c.value;
        final allNormal =
            a.type == BlockType.normal &&
            b.type == BlockType.normal &&
            c.type == BlockType.normal;

        if (isConsecutive && isSameValue && allNormal) {
          final merged = Block(
            value: a.value * 4,
            position: b.position,
            type: BlockType.normal,
            isMerging: true,
          );

          blocks.remove(a);
          blocks.remove(b);
          blocks.remove(c);
          blocks.add(merged);

          state = state.copyWith(score: state.score + merged.value);

          didMerge = true;

          Future.delayed(const Duration(milliseconds: 750), () {
            final reset = state.blocks
                .map((b) => b.isMerging ? b.copyWith(isMerging: false) : b)
                .toList();
            state = state.copyWith(blocks: reset);
          });

          break;
        }
      }
      if (didMerge) break;
    }

    if (!didMerge) {
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
    }

    state = state.copyWith(blocks: blocks);

    if (didMerge) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final reset = state.blocks
            .map((b) => b.isMerging ? b.copyWith(isMerging: false) : b)
            .toList();
        state = state.copyWith(blocks: reset);
      });
      Future.delayed(const Duration(milliseconds: 400), _mergeBlocks);
    }

    bool contains2048 = blocks.any((b) => b.value >= 2048);
    if (contains2048 && !state.isVictory) {
      stopGame();
      state = state.copyWith(isVictory: true, fallingBlock: null);
      return;
    }
  }

  void _activateBomb(Block bomb, List<Block> blockList) {
    final radius = bomb.type == BlockType.bombSmall ? 1 : 2;

    final remainingBlocks = blockList
        .where((b) => !bomb.position.isNeighborOf(b.position, radius: radius))
        .toList();
    final explodedBlocks = blockList
        .where((b) => bomb.position.isNeighborOf(b.position, radius: radius))
        .toList();

    final scoreGained = explodedBlocks.fold<int>(0, (sum, b) => sum + b.value);

    state = state.copyWith(
      blocks: remainingBlocks,
      score: state.score + scoreGained,
    );
  }

  void moveLeft() {
    final now = DateTime.now();
    if (_lastMoveTime != null &&
        now.difference(_lastMoveTime!) < moveCooldown) {
      return;
    }
    _lastMoveTime = now;

    final falling = state.fallingBlock;
    if (falling == null) return;

    final newPos = Position(max(0, falling.position.x - 1), falling.position.y);
    if (!_isCollision(newPos)) {
      state = state.copyWith(
        fallingBlock: falling.copyWith(position: newPos, preserveId: true),
      );
    }
  }

  void moveRight() {
    final now = DateTime.now();
    if (_lastMoveTime != null &&
        now.difference(_lastMoveTime!) < moveCooldown) {
      return;
    }
    _lastMoveTime = now;
    final falling = state.fallingBlock;
    if (falling == null) return;

    final newPos = Position(
      min(columns - 1, falling.position.x + 1),
      falling.position.y,
    );
    if (!_isCollision(newPos)) {
      state = state.copyWith(
        fallingBlock: falling.copyWith(position: newPos, preserveId: true),
      );
    }
  }

  void activateBombMode(BlockType type) {
    bombMode = true;
    selectedBombType = type;
  }

  void _startBombCooldownTimer() {
    _bombCooldownStart = DateTime.now();
    _bombChargeProgress = 0.0;

    _bombCooldownTimer?.cancel();
    _bombCooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(_bombCooldownStart);
      final progress = elapsed.inMilliseconds / bombCooldown.inMilliseconds;

      _bombChargeProgress = progress.clamp(0.0, 1.0);

      state = state.copyWith();

      if (_bombChargeProgress >= 1.0) {
        _bombCooldownTimer?.cancel();
      }
    });
  }

  void useBomb(BlockType type) {
    if (!isBombReady) return;

    activateBombMode(type);
    _startBombCooldownTimer();
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

  @override
  void dispose() {
    _bombCooldownTimer?.cancel();
    _countdownTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}

// ---DEBUG ONLY---
extension GameControllerDebugExtensions on GameController {
  void debugMergeBlocksForTest() {
    _mergeBlocks();
  }
}