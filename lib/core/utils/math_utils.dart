import 'dart:math';

class MathUtils {
  const MathUtils._();

  static final Random _random = Random();

  static double randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  static int randomInt(int min, int max) {
    return min + _random.nextInt(max - min);
  }

  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }
}
