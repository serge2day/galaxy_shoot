import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/hangar/domain/ship_definition.dart';

import '../helpers/test_helpers.dart';

void main() {
  test('catalog has exactly 6 ships', () {
    expect(ShipCatalog.ships.length, 6);
  });

  test('vanguard is the default starter ship', () {
    final ship = ShipCatalog.getById('vanguard');
    expect(ship.unlockCost, 0);
    expect(ship.displayName, 'Vanguard');
  });

  test('phantom costs 500 credits', () {
    final ship = ShipCatalog.getById('phantom');
    expect(ship.unlockCost, 500);
  });

  test('titan costs 1000 credits', () {
    final ship = ShipCatalog.getById('titan');
    expect(ship.unlockCost, 1000);
  });

  test('getById falls back to first ship for unknown id', () {
    final ship = ShipCatalog.getById('nonexistent');
    expect(ship.id, 'vanguard');
  });

  test('each ship has unique visual style', () {
    final styles = ShipCatalog.ships.map((s) => s.visualStyle).toSet();
    expect(styles.length, 6);
  });

  test('all ships have unique ids', () {
    final ids = ShipCatalog.ships.map((s) => s.id).toSet();
    expect(ids.length, 6);
  });

  group('ship catalog repository', () {
    late FakeShipCatalogRepository repo;

    setUp(() {
      repo = FakeShipCatalogRepository();
    });

    test('starts with vanguard unlocked and selected', () async {
      expect(await repo.getUnlockedShipIds(), ['vanguard']);
      expect(await repo.getSelectedShipId(), 'vanguard');
    });

    test('unlock adds ship to unlocked list', () async {
      await repo.unlockShip('phantom');
      final unlocked = await repo.getUnlockedShipIds();
      expect(unlocked, contains('phantom'));
    });

    test('duplicate unlock does not add twice', () async {
      await repo.unlockShip('phantom');
      await repo.unlockShip('phantom');
      final unlocked = await repo.getUnlockedShipIds();
      expect(unlocked.where((id) => id == 'phantom').length, 1);
    });

    test('select changes selected ship', () async {
      await repo.selectShip('titan');
      expect(await repo.getSelectedShipId(), 'titan');
    });
  });
}
