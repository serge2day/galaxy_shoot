import 'dart:ui';

enum PickupType {
  weaponBoost,
  shield,
  heal;

  String get label {
    switch (this) {
      case PickupType.weaponBoost:
        return 'W';
      case PickupType.shield:
        return 'S';
      case PickupType.heal:
        return 'H';
    }
  }

  Color get color {
    switch (this) {
      case PickupType.weaponBoost:
        return const Color(0xFFFFD600);
      case PickupType.shield:
        return const Color(0xFF00B0FF);
      case PickupType.heal:
        return const Color(0xFF69F0AE);
    }
  }
}
