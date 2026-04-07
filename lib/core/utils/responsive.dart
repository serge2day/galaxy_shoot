import 'package:flutter/material.dart';

/// Responsive scaling utilities based on screen size.
/// Reference design: 390 x 844 (iPhone 14 / typical phone)
class Responsive {
  static double _width = 390;
  static double _height = 844;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width > 0 && size.height > 0) {
      _width = size.width;
      _height = size.height;
    }
  }

  /// Scale a value relative to reference width (390).
  static double w(double value) => value * _width / 390;

  /// Scale a value relative to reference height (844).
  static double h(double value) => value * _height / 844;

  /// Scale font size relative to width.
  static double sp(double value) => value * _width / 390;

  /// Screen width.
  static double get screenWidth => _width;

  /// Screen height.
  static double get screenHeight => _height;
}
