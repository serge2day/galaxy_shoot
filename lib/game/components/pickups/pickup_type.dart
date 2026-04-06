import 'dart:ui';

enum PickupType {
  evolutionCore,
  shield,
  heal,
  bombCharge;

  String get label {
    switch (this) {
      case PickupType.evolutionCore:
        return 'E';
      case PickupType.shield:
        return 'S';
      case PickupType.heal:
        return 'H';
      case PickupType.bombCharge:
        return 'B';
    }
  }

  Color get color {
    switch (this) {
      case PickupType.evolutionCore:
        return const Color(0xFFFFD600);
      case PickupType.shield:
        return const Color(0xFF00B0FF);
      case PickupType.heal:
        return const Color(0xFF69F0AE);
      case PickupType.bombCharge:
        return const Color(0xFFFF6D00);
    }
  }
}
