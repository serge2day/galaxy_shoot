abstract class ShipCatalogRepository {
  Future<List<String>> getUnlockedShipIds();
  Future<String> getSelectedShipId();
  Future<void> unlockShip(String shipId);
  Future<void> selectShip(String shipId);
}
