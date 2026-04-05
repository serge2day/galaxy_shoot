import 'difficulty_tier.dart';

class DifficultyModifiers {
  final double enemyHpMultiplier;
  final double enemyFireRateMultiplier;
  final double bossHpMultiplier;
  final double bossFireRateMultiplier;
  final double rewardMultiplier;

  const DifficultyModifiers({
    required this.enemyHpMultiplier,
    required this.enemyFireRateMultiplier,
    required this.bossHpMultiplier,
    required this.bossFireRateMultiplier,
    required this.rewardMultiplier,
  });
}

class DifficultyConfig {
  const DifficultyConfig._();

  static const Map<DifficultyTier, DifficultyModifiers> modifiers = {
    DifficultyTier.normal: DifficultyModifiers(
      enemyHpMultiplier: 1.0,
      enemyFireRateMultiplier: 1.0,
      bossHpMultiplier: 1.0,
      bossFireRateMultiplier: 1.0,
      rewardMultiplier: 1.0,
    ),
    DifficultyTier.veteran: DifficultyModifiers(
      enemyHpMultiplier: 1.5,
      enemyFireRateMultiplier: 0.8,
      bossHpMultiplier: 1.5,
      bossFireRateMultiplier: 0.75,
      rewardMultiplier: 1.5,
    ),
    DifficultyTier.expert: DifficultyModifiers(
      enemyHpMultiplier: 2.0,
      enemyFireRateMultiplier: 0.6,
      bossHpMultiplier: 2.0,
      bossFireRateMultiplier: 0.55,
      rewardMultiplier: 2.5,
    ),
  };

  static DifficultyModifiers getModifiers(DifficultyTier tier) {
    return modifiers[tier]!;
  }
}
