import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_tier.dart';
import 'package:galaxy_shoot/features/progression/domain/reward_calculator.dart';

void main() {
  test('calculates basic rewards for normal difficulty', () {
    final result = RewardCalculator.calculate(
      enemyKills: 10,
      bossDefeated: false,
      isVictory: false,
      difficulty: DifficultyTier.normal,
    );
    expect(result.enemyKillCredits, 30); // 10 * 3
    expect(result.bossDefeatCredits, 0);
    expect(result.victoryBonusCredits, 0);
    expect(result.totalCredits, 30);
  });

  test('includes boss and victory bonuses', () {
    final result = RewardCalculator.calculate(
      enemyKills: 20,
      bossDefeated: true,
      isVictory: true,
      difficulty: DifficultyTier.normal,
    );
    expect(result.enemyKillCredits, 60); // 20 * 3
    expect(result.bossDefeatCredits, 80);
    expect(result.victoryBonusCredits, 50);
    expect(result.totalCredits, 190);
  });

  test('difficulty multiplier increases rewards', () {
    final normal = RewardCalculator.calculate(
      enemyKills: 10,
      bossDefeated: true,
      isVictory: true,
      difficulty: DifficultyTier.normal,
    );
    final expert = RewardCalculator.calculate(
      enemyKills: 10,
      bossDefeated: true,
      isVictory: true,
      difficulty: DifficultyTier.expert,
    );
    expect(expert.totalCredits, greaterThan(normal.totalCredits));
  });

  test('veteran gives more than normal', () {
    final normal = RewardCalculator.calculate(
      enemyKills: 10,
      bossDefeated: false,
      isVictory: false,
      difficulty: DifficultyTier.normal,
    );
    final veteran = RewardCalculator.calculate(
      enemyKills: 10,
      bossDefeated: false,
      isVictory: false,
      difficulty: DifficultyTier.veteran,
    );
    expect(veteran.totalCredits, greaterThan(normal.totalCredits));
  });
}
