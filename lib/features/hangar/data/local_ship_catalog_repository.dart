import '../../../core/persistence/key_value_store.dart';
import '../domain/ship_catalog_repository.dart';

class LocalShipCatalogRepository implements ShipCatalogRepository {
  final KeyValueStore _store;

  static const String _unlockedKey = 'unlocked_ships';
  static const String _selectedKey = 'selected_ship';
  static const String _defaultShipId = 'vanguard';

  LocalShipCatalogRepository(this._store);

  @override
  Future<List<String>> getUnlockedShipIds() async {
    final raw = await _store.getString(_unlockedKey);
    if (raw == null || raw.isEmpty) return [_defaultShipId];
    return raw.split(',');
  }

  @override
  Future<String> getSelectedShipId() async {
    return await _store.getString(_selectedKey) ?? _defaultShipId;
  }

  @override
  Future<void> unlockShip(String shipId) async {
    final current = await getUnlockedShipIds();
    if (!current.contains(shipId)) {
      current.add(shipId);
      await _store.setString(_unlockedKey, current.join(','));
    }
  }

  @override
  Future<void> selectShip(String shipId) async {
    await _store.setString(_selectedKey, shipId);
  }
}
