import 'difficulty_config.dart';
import 'difficulty_tier.dart';
import 'reward_breakdown.dart';

class RewardCalculator {
  const RewardCalculator._();

  static const int creditsPerEnemyKill = 3;
  static const int creditsPerBossDefeat = 80;
  static const int victoryBonus = 50;

  static RewardBreakdown calculate({
    required int enemyKills,
    required bool bossDefeated,
    required bool isVictory,
    required DifficultyTier difficulty,
  }) {
    final mods = DifficultyConfig.getModifiers(difficulty);
    return RewardBreakdown(
      enemyKillCredits: enemyKills * creditsPerEnemyKill,
      bossDefeatCredits: bossDefeated ? creditsPerBossDefeat : 0,
      victoryBonusCredits: isVictory ? victoryBonus : 0,
      difficultyMultiplier: mods.rewardMultiplier,
      difficulty: difficulty,
    );
  }
}
