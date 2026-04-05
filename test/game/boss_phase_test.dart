import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/config/game_balance.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_config.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_tier.dart';
import 'package:galaxy_shoot/game/components/boss/boss_ship.dart';

void main() {
  test('boss phase 2 triggers at correct HP threshold', () {
    final threshold = (GameBalance.bossHp * GameBalance.bossPhase2HpRatio)
        .toInt();
    expect(threshold, greaterThan(0));
    expect(threshold, lessThan(GameBalance.bossHp));
  });

  test('boss HP is scaled by difficulty', () {
    final normalHp =
        (GameBalance.bossHp *
                DifficultyConfig.getModifiers(
                  DifficultyTier.normal,
                ).bossHpMultiplier)
            .ceil();
    final expertHp =
        (GameBalance.bossHp *
                DifficultyConfig.getModifiers(
                  DifficultyTier.expert,
                ).bossHpMultiplier)
            .ceil();
    expect(expertHp, greaterThan(normalHp));
  });

  test('BossPhase enum has all phases', () {
    expect(BossPhase.values.length, 3);
    expect(BossPhase.values, contains(BossPhase.entering));
    expect(BossPhase.values, contains(BossPhase.phase1));
    expect(BossPhase.values, contains(BossPhase.phase2));
  });

  test('boss phase 2 fire cooldown is shorter', () {
    expect(
      GameBalance.bossPhase2FireCooldown,
      lessThan(GameBalance.bossFireCooldown),
    );
  });

  test('boss phase 2 speed is higher', () {
    expect(GameBalance.bossPhase2Speed, greaterThan(GameBalance.bossSpeed));
  });
}
