import 'package:flame/components.dart';

extension Vector2Ext on Vector2 {
  bool isWithinBounds(double width, double height, {double margin = 0}) {
    return x >= -margin &&
        x <= width + margin &&
        y >= -margin &&
        y <= height + margin;
  }
}
