import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/hangar/data/local_ship_catalog_repository.dart';

import '../helpers/test_helpers.dart';

void main() {
  late InMemoryStore store;
  late LocalShipCatalogRepository repo;

  setUp(() {
    store = InMemoryStore();
    repo = LocalShipCatalogRepository(store);
  });

  test('defaults to vanguard unlocked', () async {
    final ids = await repo.getUnlockedShipIds();
    expect(ids, contains('vanguard'));
  });

  test('defaults to vanguard selected', () async {
    expect(await repo.getSelectedShipId(), 'vanguard');
  });

  test('unlock persists new ship', () async {
    await repo.unlockShip('phantom');
    final ids = await repo.getUnlockedShipIds();
    expect(ids, containsAll(['vanguard', 'phantom']));
  });

  test('duplicate unlock is safe', () async {
    await repo.unlockShip('phantom');
    await repo.unlockShip('phantom');
    final ids = await repo.getUnlockedShipIds();
    expect(ids.where((id) => id == 'phantom').length, 1);
  });

  test('select persists ship id', () async {
    await repo.selectShip('titan');
    expect(await repo.getSelectedShipId(), 'titan');
  });
}
