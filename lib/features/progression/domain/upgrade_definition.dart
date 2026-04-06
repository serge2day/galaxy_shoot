import 'upgrade_type.dart';

class UpgradeLevel {
  final int level;
  final int cost;
  final double value;

  const UpgradeLevel({
    required this.level,
    required this.cost,
    required this.value,
  });
}

class UpgradeDefinition {
  final UpgradeType type;
  final List<UpgradeLevel> levels;

  const UpgradeDefinition({required this.type, required this.levels});

  int get maxLevel => levels.length;

  int costForLevel(int level) {
    if (level < 1 || level > maxLevel) return -1;
    return levels[level - 1].cost;
  }

  double valueAtLevel(int level) {
    if (level < 0 || level > maxLevel) return 0;
    if (level == 0) return 0;
    return levels[level - 1].value;
  }
}

class UpgradeConfig {
  const UpgradeConfig._();

  static const List<UpgradeDefinition> definitions = [
    UpgradeDefinition(
      type: UpgradeType.maxHp,
      levels: [
        UpgradeLevel(level: 1, cost: 300, value: 1),
        UpgradeLevel(level: 2, cost: 800, value: 2),
        UpgradeLevel(level: 3, cost: 1500, value: 3),
        UpgradeLevel(level: 4, cost: 2500, value: 4),
        UpgradeLevel(level: 5, cost: 4000, value: 5),
      ],
    ),
    UpgradeDefinition(
      type: UpgradeType.fireRate,
      levels: [
        UpgradeLevel(level: 1, cost: 400, value: 0.02),
        UpgradeLevel(level: 2, cost: 900, value: 0.04),
        UpgradeLevel(level: 3, cost: 1600, value: 0.06),
        UpgradeLevel(level: 4, cost: 2800, value: 0.08),
        UpgradeLevel(level: 5, cost: 4500, value: 0.10),
      ],
    ),
    UpgradeDefinition(
      type: UpgradeType.bulletDamage,
      levels: [
        UpgradeLevel(level: 1, cost: 500, value: 1),
        UpgradeLevel(level: 2, cost: 1200, value: 2),
        UpgradeLevel(level: 3, cost: 2200, value: 3),
        UpgradeLevel(level: 4, cost: 3500, value: 4),
        UpgradeLevel(level: 5, cost: 5000, value: 5),
      ],
    ),
    UpgradeDefinition(
      type: UpgradeType.movementSpeed,
      levels: [
        UpgradeLevel(level: 1, cost: 300, value: 30),
        UpgradeLevel(level: 2, cost: 750, value: 60),
        UpgradeLevel(level: 3, cost: 1400, value: 90),
        UpgradeLevel(level: 4, cost: 2200, value: 120),
        UpgradeLevel(level: 5, cost: 3500, value: 150),
      ],
    ),
  ];

  static UpgradeDefinition getDefinition(UpgradeType type) {
    return definitions.firstWhere((d) => d.type == type);
  }
}
