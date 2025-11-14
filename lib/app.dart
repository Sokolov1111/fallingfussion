import 'package:fallingfusion/ui/screens/game_screen.dart';
import 'package:fallingfusion/ui/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';

class FallingFusionApp extends StatelessWidget {
  const FallingFusionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FallingFusion',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: MainMenuScreen(),
    );
  }
}