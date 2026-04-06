import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/hangar/domain/resolved_ship_stats.dart';
import 'package:galaxy_shoot/features/hangar/domain/ship_definition.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_state.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_type.dart';

void main() {
  test('no upgrades returns base stats', () {
    final ship = ShipCatalog.getById('vanguard');
    final stats = ResolvedShipStats.resolve(
      ship: ship,
      upgrades: const UpgradeState(),
    );
    expect(stats.maxHp, ship.baseStats.maxHp);
    expect(stats.speed, ship.baseStats.speed);
    expect(stats.bulletDamage, ship.baseStats.bulletDamage);
    expect(stats.fireCooldown, ship.baseStats.fireCooldown);
  });

  test('maxHp upgrade increases HP', () {
    final ship = ShipCatalog.getById('vanguard');
    final upgrades = const UpgradeState().withUpgrade(
      UpgradeType.maxHp,
      3,
    ); // +3 HP
    final stats = ResolvedShipStats.resolve(ship: ship, upgrades: upgrades);
    expect(stats.maxHp, ship.baseStats.maxHp + 3);
  });

  test('fire rate upgrade reduces cooldown', () {
    final ship = ShipCatalog.getById('vanguard');
    final upgrades = const UpgradeState().withUpgrade(UpgradeType.fireRate, 2);
    final stats = ResolvedShipStats.resolve(ship: ship, upgrades: upgrades);
    expect(stats.fireCooldown, lessThan(ship.baseStats.fireCooldown));
  });

  test('bullet damage upgrade increases damage', () {
    final ship = ShipCatalog.getById('vanguard');
    final upgrades = const UpgradeState().withUpgrade(
      UpgradeType.bulletDamage,
      1,
    ); // +1
    final stats = ResolvedShipStats.resolve(ship: ship, upgrades: upgrades);
    expect(stats.bulletDamage, ship.baseStats.bulletDamage + 1);
  });

  test('movement speed upgrade increases speed', () {
    final ship = ShipCatalog.getById('vanguard');
    final upgrades = const UpgradeState().withUpgrade(
      UpgradeType.movementSpeed,
      2,
    ); // +60
    final stats = ResolvedShipStats.resolve(ship: ship, upgrades: upgrades);
    expect(stats.speed, ship.baseStats.speed + 60);
  });

  test('upgrades apply to different ships', () {
    final phantom = ShipCatalog.getById('phantom');
    final titan = ShipCatalog.getById('titan');
    final upgrades = const UpgradeState().withUpgrade(UpgradeType.maxHp, 2);

    final phantomStats = ResolvedShipStats.resolve(
      ship: phantom,
      upgrades: upgrades,
    );
    final titanStats = ResolvedShipStats.resolve(
      ship: titan,
      upgrades: upgrades,
    );

    expect(phantomStats.maxHp, phantom.baseStats.maxHp + 2);
    expect(titanStats.maxHp, titan.baseStats.maxHp + 2);
    expect(titanStats.maxHp, greaterThan(phantomStats.maxHp));
  });

  test('fire cooldown has minimum floor', () {
    final ship = ShipCatalog.getById('phantom'); // already fast: 0.14s
    final upgrades = const UpgradeState().withUpgrade(
      UpgradeType.fireRate,
      5,
    ); // -0.10
    final stats = ResolvedShipStats.resolve(ship: ship, upgrades: upgrades);
    // Should clamp to 0.06 minimum
    expect(stats.fireCooldown, greaterThanOrEqualTo(0.06));
  });
}
