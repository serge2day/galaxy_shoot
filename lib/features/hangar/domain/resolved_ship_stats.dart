import '../../progression/domain/upgrade_definition.dart';
import '../../progression/domain/upgrade_state.dart';
import '../../progression/domain/upgrade_type.dart';
import 'ship_definition.dart';
import 'ship_stats.dart';

class ResolvedShipStats {
  const ResolvedShipStats._();

  static ShipStats resolve({
    required ShipDefinition ship,
    required UpgradeState upgrades,
  }) {
    final base = ship.baseStats;

    final hpBonus = UpgradeConfig.getDefinition(
      UpgradeType.maxHp,
    ).valueAtLevel(upgrades.levelOf(UpgradeType.maxHp)).toInt();

    final fireRateReduction = UpgradeConfig.getDefinition(
      UpgradeType.fireRate,
    ).valueAtLevel(upgrades.levelOf(UpgradeType.fireRate));

    final damageBonus = UpgradeConfig.getDefinition(
      UpgradeType.bulletDamage,
    ).valueAtLevel(upgrades.levelOf(UpgradeType.bulletDamage)).toInt();

    final speedBonus = UpgradeConfig.getDefinition(
      UpgradeType.movementSpeed,
    ).valueAtLevel(upgrades.levelOf(UpgradeType.movementSpeed));

    return base.copyWith(
      maxHp: base.maxHp + hpBonus,
      fireCooldown: (base.fireCooldown - fireRateReduction).clamp(0.06, 1.0),
      bulletDamage: base.bulletDamage + damageBonus,
      speed: base.speed + speedBonus,
    );
  }
}
