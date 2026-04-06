abstract class ShipCatalogService {
  List<String> getAvailableShips();
  String getSelectedShip();
  Future<void> selectShip(String shipId);
}
