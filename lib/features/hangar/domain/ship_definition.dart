import 'ship_stats.dart';

enum ShipVisualStyle { balanced, swift, heavy }

class ShipDefinition {
  final String id;
  final String displayName;
  final String description;
  final int unlockCost;
  final ShipStats baseStats;
  final ShipVisualStyle visualStyle;

  const ShipDefinition({
    required this.id,
    required this.displayName,
    required this.description,
    required this.unlockCost,
    required this.baseStats,
    required this.visualStyle,
  });
}

class ShipCatalog {
  const ShipCatalog._();

  static const List<ShipDefinition> ships = [
    ShipDefinition(
      id: 'vanguard',
      displayName: 'Vanguard',
      description: 'Balanced starter ship. Reliable all-around.',
      unlockCost: 0,
      baseStats: ShipStats(
        maxHp: 5,
        startingLives: 3,
        speed: 500,
        fireCooldown: 0.18,
        bulletDamage: 1,
        shipWidth: 40,
        shipHeight: 48,
      ),
      visualStyle: ShipVisualStyle.balanced,
    ),
    ShipDefinition(
      id: 'phantom',
      displayName: 'Phantom',
      description: 'Fast and agile, but fragile.',
      unlockCost: 500,
      baseStats: ShipStats(
        maxHp: 3,
        startingLives: 3,
        speed: 650,
        fireCooldown: 0.14,
        bulletDamage: 1,
        shipWidth: 34,
        shipHeight: 44,
        hitboxScale: 0.6,
      ),
      visualStyle: ShipVisualStyle.swift,
    ),
    ShipDefinition(
      id: 'titan',
      displayName: 'Titan',
      description: 'Slow and tough. Hits hard.',
      unlockCost: 800,
      baseStats: ShipStats(
        maxHp: 8,
        startingLives: 3,
        speed: 380,
        fireCooldown: 0.22,
        bulletDamage: 2,
        shipWidth: 48,
        shipHeight: 54,
        hitboxScale: 0.75,
      ),
      visualStyle: ShipVisualStyle.heavy,
    ),
  ];

  static ShipDefinition getById(String id) {
    return ships.firstWhere((s) => s.id == id, orElse: () => ships.first);
  }
}
