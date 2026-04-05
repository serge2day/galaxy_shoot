import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/settings/domain/fire_mode.dart';

void main() {
  test('fromString returns correct mode for auto', () {
    expect(FireMode.fromString('auto'), FireMode.auto);
  });

  test('fromString returns correct mode for manual', () {
    expect(FireMode.fromString('manual'), FireMode.manual);
  });

  test('fromString defaults to auto for unknown value', () {
    expect(FireMode.fromString('unknown'), FireMode.auto);
  });
}
