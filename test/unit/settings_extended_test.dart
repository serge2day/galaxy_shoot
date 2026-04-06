import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/settings/domain/fire_mode.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';

void main() {
  test('default settings have audio and haptics enabled', () {
    const settings = GameSettings();
    expect(settings.musicEnabled, true);
    expect(settings.sfxEnabled, true);
    expect(settings.hapticsEnabled, true);
  });

  test('copyWith preserves unchanged fields', () {
    const settings = GameSettings();
    final updated = settings.copyWith(musicEnabled: false);
    expect(updated.musicEnabled, false);
    expect(updated.sfxEnabled, true);
    expect(updated.hapticsEnabled, true);
    expect(updated.fireMode, FireMode.auto);
  });

  test('equality with extended fields', () {
    const a = GameSettings(musicEnabled: false);
    const b = GameSettings(musicEnabled: false);
    const c = GameSettings(musicEnabled: true);
    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
