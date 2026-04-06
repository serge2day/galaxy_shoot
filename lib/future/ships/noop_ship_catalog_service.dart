import 'ship_catalog_service.dart';

class NoopShipCatalogService implements ShipCatalogService {
  @override
  List<String> getAvailableShips() => ['default'];

  @override
  String getSelectedShip() => 'default';

  @override
  Future<void> selectShip(String shipId) async {}
}
