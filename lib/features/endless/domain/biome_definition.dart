import 'dart:ui';

enum BiomeId {
  frontierVoid,
  nebulaDrift,
  wardenBelt,
  crimsonRift,
  ruinOrbit,
  coreAbyss;

  String get displayName {
    switch (this) {
      case BiomeId.frontierVoid:
        return 'Frontier Void';
      case BiomeId.nebulaDrift:
        return 'Nebula Drift';
      case BiomeId.wardenBelt:
        return 'Warden Belt';
      case BiomeId.crimsonRift:
        return 'Crimson Rift';
      case BiomeId.ruinOrbit:
        return 'Ruin Orbit';
      case BiomeId.coreAbyss:
        return 'Core Abyss';
    }
  }
}

class BiomeDefinition {
  final BiomeId id;
  final Color bgTint;
  final double starSpeed;
  final double enemyHpScale;
  final double eliteChance;
  final double hazardDensity;
  final double rewardMultiplier;
  final List<String> enemyWeights; // enemy type names weighted
  final int minDifficulty; // minimum sector depth to appear

  const BiomeDefinition({
    required this.id,
    required this.bgTint,
    this.starSpeed = 1.0,
    this.enemyHpScale = 1.0,
    this.eliteChance = 0.05,
    this.hazardDensity = 0.3,
    this.rewardMultiplier = 1.0,
    this.enemyWeights = const ['drone', 'interceptor'],
    this.minDifficulty = 0,
  });
}

class BiomeRegistry {
  const BiomeRegistry._();

  static const List<BiomeDefinition> biomes = [
    BiomeDefinition(
      id: BiomeId.frontierVoid,
      bgTint: Color(0xFF050A18),
      starSpeed: 1.0,
      enemyHpScale: 1.0,
      eliteChance: 0.03,
      hazardDensity: 0.2,
      rewardMultiplier: 1.0,
      enemyWeights: ['drone', 'drone', 'interceptor'],
      minDifficulty: 0,
    ),
    BiomeDefinition(
      id: BiomeId.nebulaDrift,
      bgTint: Color(0xFF0D0520),
      starSpeed: 1.2,
      enemyHpScale: 1.1,
      eliteChance: 0.05,
      hazardDensity: 0.3,
      rewardMultiplier: 1.1,
      enemyWeights: ['drone', 'interceptor', 'swarmer', 'swarmer'],
      minDifficulty: 1,
    ),
    BiomeDefinition(
      id: BiomeId.wardenBelt,
      bgTint: Color(0xFF0A1020),
      starSpeed: 1.3,
      enemyHpScale: 1.2,
      eliteChance: 0.08,
      hazardDensity: 0.5,
      rewardMultiplier: 1.2,
      enemyWeights: ['drone', 'interceptor', 'gunship', 'swarmer'],
      minDifficulty: 3,
    ),
    BiomeDefinition(
      id: BiomeId.crimsonRift,
      bgTint: Color(0xFF180808),
      starSpeed: 1.4,
      enemyHpScale: 1.4,
      eliteChance: 0.10,
      hazardDensity: 0.4,
      rewardMultiplier: 1.4,
      enemyWeights: ['interceptor', 'gunship', 'swarmer', 'carrier'],
      minDifficulty: 5,
    ),
    BiomeDefinition(
      id: BiomeId.ruinOrbit,
      bgTint: Color(0xFF100810),
      starSpeed: 1.5,
      enemyHpScale: 1.6,
      eliteChance: 0.12,
      hazardDensity: 0.5,
      rewardMultiplier: 1.6,
      enemyWeights: ['gunship', 'carrier', 'interceptor', 'swarmer'],
      minDifficulty: 8,
    ),
    BiomeDefinition(
      id: BiomeId.coreAbyss,
      bgTint: Color(0xFF200808),
      starSpeed: 1.8,
      enemyHpScale: 2.0,
      eliteChance: 0.15,
      hazardDensity: 0.6,
      rewardMultiplier: 2.0,
      enemyWeights: ['carrier', 'gunship', 'interceptor', 'swarmer', 'carrier'],
      minDifficulty: 12,
    ),
  ];

  static BiomeDefinition getById(BiomeId id) {
    return biomes.firstWhere((b) => b.id == id);
  }

  static List<BiomeDefinition> availableAt(int sectorDepth) {
    return biomes.where((b) => b.minDifficulty <= sectorDepth).toList();
  }
}
