import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_definition.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_state.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_type.dart';

void main() {
  test('upgrade config has 4 upgrade types', () {
    expect(UpgradeConfig.definitions.length, 4);
  });

  test('each upgrade has max level 5', () {
    for (final def in UpgradeConfig.definitions) {
      expect(def.maxLevel, 5);
    }
  });

  test('costs increase with level', () {
    for (final def in UpgradeConfig.definitions) {
      for (int i = 1; i < def.maxLevel; i++) {
        expect(
          def.costForLevel(i + 1),
          greaterThan(def.costForLevel(i)),
          reason: '${def.type.name} level ${i + 1} should cost more than $i',
        );
      }
    }
  });

  test('values increase with level', () {
    for (final def in UpgradeConfig.definitions) {
      for (int i = 1; i < def.maxLevel; i++) {
        expect(
          def.valueAtLevel(i + 1),
          greaterThan(def.valueAtLevel(i)),
          reason: '${def.type.name} level ${i + 1} should give more than $i',
        );
      }
    }
  });

  test('costForLevel returns -1 for invalid level', () {
    final def = UpgradeConfig.getDefinition(UpgradeType.maxHp);
    expect(def.costForLevel(0), -1);
    expect(def.costForLevel(6), -1);
  });

  test('valueAtLevel returns 0 for level 0', () {
    final def = UpgradeConfig.getDefinition(UpgradeType.maxHp);
    expect(def.valueAtLevel(0), 0);
  });

  test('upgrade state tracks levels', () {
    const state = UpgradeState();
    expect(state.levelOf(UpgradeType.maxHp), 0);

    final updated = state.withUpgrade(UpgradeType.maxHp, 3);
    expect(updated.levelOf(UpgradeType.maxHp), 3);
    expect(updated.levelOf(UpgradeType.fireRate), 0);
  });

  test('upgrade state equality', () {
    final a = const UpgradeState().withUpgrade(UpgradeType.maxHp, 2);
    final b = const UpgradeState().withUpgrade(UpgradeType.maxHp, 2);
    final c = const UpgradeState().withUpgrade(UpgradeType.maxHp, 3);
    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
