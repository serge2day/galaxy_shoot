import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_config.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_tier.dart';

void main() {
  test('normal has multiplier 1.0 for all values', () {
    final mods = DifficultyConfig.getModifiers(DifficultyTier.normal);
    expect(mods.enemyHpMultiplier, 1.0);
    expect(mods.enemyFireRateMultiplier, 1.0);
    expect(mods.bossHpMultiplier, 1.0);
    expect(mods.rewardMultiplier, 1.0);
  });

  test('veteran is harder than normal', () {
    final normal = DifficultyConfig.getModifiers(DifficultyTier.normal);
    final veteran = DifficultyConfig.getModifiers(DifficultyTier.veteran);
    expect(veteran.enemyHpMultiplier, greaterThan(normal.enemyHpMultiplier));
    expect(veteran.rewardMultiplier, greaterThan(normal.rewardMultiplier));
  });

  test('expert is harder than veteran', () {
    final veteran = DifficultyConfig.getModifiers(DifficultyTier.veteran);
    final expert = DifficultyConfig.getModifiers(DifficultyTier.expert);
    expect(expert.enemyHpMultiplier, greaterThan(veteran.enemyHpMultiplier));
    expect(expert.bossHpMultiplier, greaterThan(veteran.bossHpMultiplier));
    expect(expert.rewardMultiplier, greaterThan(veteran.rewardMultiplier));
  });

  test('fire rate multipliers decrease (faster enemies)', () {
    final normal = DifficultyConfig.getModifiers(DifficultyTier.normal);
    final expert = DifficultyConfig.getModifiers(DifficultyTier.expert);
    // Lower multiplier = faster fire rate (shorter cooldown)
    expect(
      expert.enemyFireRateMultiplier,
      lessThan(normal.enemyFireRateMultiplier),
    );
  });

  test('fromString parses correctly', () {
    expect(DifficultyTier.fromString('normal'), DifficultyTier.normal);
    expect(DifficultyTier.fromString('veteran'), DifficultyTier.veteran);
    expect(DifficultyTier.fromString('expert'), DifficultyTier.expert);
    expect(DifficultyTier.fromString('unknown'), DifficultyTier.normal);
  });

  test('all tiers have modifiers defined', () {
    for (final tier in DifficultyTier.values) {
      expect(DifficultyConfig.modifiers.containsKey(tier), true);
    }
  });
}
