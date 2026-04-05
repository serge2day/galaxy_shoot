import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/settings/domain/fire_mode.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';

void main() {
  test('default fire mode is auto', () {
    const settings = GameSettings();
    expect(settings.fireMode, FireMode.auto);
  });

  test('copyWith creates new instance with changed field', () {
    const settings = GameSettings(fireMode: FireMode.auto);
    final updated = settings.copyWith(fireMode: FireMode.manual);
    expect(updated.fireMode, FireMode.manual);
    expect(settings.fireMode, FireMode.auto);
  });

  test('equality works correctly', () {
    const a = GameSettings(fireMode: FireMode.auto);
    const b = GameSettings(fireMode: FireMode.auto);
    const c = GameSettings(fireMode: FireMode.manual);
    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
