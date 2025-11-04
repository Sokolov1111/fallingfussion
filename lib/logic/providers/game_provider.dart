
import 'package:fallingfusion/data/models/game_state.dart';
import 'package:fallingfusion/logic/controllers/game_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>(
        (ref) => GameController(),
    );
