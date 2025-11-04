import 'package:flutter/material.dart';

class AppColors {
  static const boardBackground = Color(0xFF2C2C2C);
  static const boardBorder = Color(0xFF444444);

  static Color numberColor(int value) {
    return switch(value) {
      2 => Colors.blueAccent,
      4 => Colors.greenAccent,
      8 => Colors.yellowAccent,
      16 => Colors.orange,
      32 => Colors.deepOrange,
      64 => Colors.red,
      _ => Colors.purpleAccent,
    };
  }
}