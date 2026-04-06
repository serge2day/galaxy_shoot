import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_id.dart';
import 'package:galaxy_shoot/features/hangar/domain/ship_stats.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_tier.dart';
import 'package:galaxy_shoot/features/settings/domain/fire_mode.dart';
import 'package:galaxy_shoot/game/galaxy_game.dart';

void main() {
  test('claimResult returns null on second call (prevents double claim)', () {
    int endCallCount = 0;
    final game = GalaxyGame(
      fireMode: FireMode.auto,
      shipStats: const ShipStats(
        maxHp: 5,
        startingLives: 3,
        speed: 500,
        fireCooldown: 0.18,
        bulletDamage: 1,
        shipWidth: 40,
        shipHeight: 48,
      ),
      difficulty: DifficultyTier.normal,
      shipId: 'vanguard',
      stageId: StageId.stage1,
      onGameEnd: (_) => endCallCount++,
    );

    // First claim succeeds
    final first = game.claimResult();
    // claimResult should work once (even though triggerGameOver/triggerVictory
    // wasn't called - it claims whatever the current state is)
    expect(first, isNotNull);

    // Second claim returns null
    final second = game.claimResult();
    expect(second, isNull);
  });

  test('enemy kills and boss defeat are tracked', () {
    final game = GalaxyGame(
      fireMode: FireMode.auto,
      shipStats: const ShipStats(
        maxHp: 5,
        startingLives: 3,
        speed: 500,
        fireCooldown: 0.18,
        bulletDamage: 1,
        shipWidth: 40,
        shipHeight: 48,
      ),
      difficulty: DifficultyTier.normal,
      shipId: 'vanguard',
      stageId: StageId.stage1,
      onGameEnd: (_) {},
    );

    game.recordEnemyKill();
    game.recordEnemyKill();
    game.recordEnemyKill();
    expect(game.enemyKills, 3);

    game.recordBossDefeat();
    expect(game.bossDefeated, true);
  });
}
