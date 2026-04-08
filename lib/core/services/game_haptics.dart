import 'flutter_haptics_service.dart';

class GameHaptics {
  GameHaptics._();

  static final FlutterHapticsService _service = FlutterHapticsService();
  static FlutterHapticsService get instance => _service;

  static void setEnabled(bool enabled) => _service.setEnabled(enabled);

  // Game triggers
  static void playerDamage() => _service.mediumImpact();
  static void playerDeath() => _service.heavyImpact();
  static void bossPhaseChange() => _service.heavyImpact();
  static void victory() => _service.heavyImpact();
  static void pickupCollect() => _service.lightImpact();
  static void evolutionUp() => _service.mediumImpact();
  static void buttonPress() => _service.lightImpact();
}
