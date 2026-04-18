// app/theme/app_gradients.dart
import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const authBackground = LinearGradient(
    colors: [Color(0xFF050505), Color(0xFF7DFF6B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.3, 1.0],
  );
}
