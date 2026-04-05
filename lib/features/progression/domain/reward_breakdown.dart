import 'difficulty_tier.dart';

class RewardBreakdown {
  final int enemyKillCredits;
  final int bossDefeatCredits;
  final int victoryBonusCredits;
  final double difficultyMultiplier;
  final DifficultyTier difficulty;

  const RewardBreakdown({
    required this.enemyKillCredits,
    required this.bossDefeatCredits,
    required this.victoryBonusCredits,
    required this.difficultyMultiplier,
    required this.difficulty,
  });

  int get totalCredits =>
      ((enemyKillCredits + bossDefeatCredits + victoryBonusCredits) *
              difficultyMultiplier)
          .round();
}
