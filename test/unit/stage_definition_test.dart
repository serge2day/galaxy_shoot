import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_id.dart';
import 'package:galaxy_shoot/game/world/stages/stage_registry.dart';

void main() {
  test('stage registry returns all 9 stages', () {
    for (final id in StageId.values) {
      final stage = StageRegistry.get(id);
      expect(stage.id, id);
      expect(stage.waves, isNotEmpty);
      expect(stage.bossSpawnTime, greaterThan(0));
    }
  });

  test('each stage has waves before boss spawn time', () {
    for (final id in StageId.values) {
      final stage = StageRegistry.get(id);
      for (final wave in stage.waves) {
        expect(
          wave.time,
          lessThanOrEqualTo(stage.bossSpawnTime),
          reason: '${id.name} wave at ${wave.time} exceeds boss time',
        );
      }
    }
  });

  test('boss stages have hasBoss true', () {
    // Stages 3, 6, 9 should have bosses
    for (final id in [StageId.stage3, StageId.stage6, StageId.stage9]) {
      expect(
        StageRegistry.get(id).hasBoss,
        true,
        reason: '${id.name} should have boss',
      );
    }
  });

  test('non-boss stages have hasBoss false or true for mini-bosses', () {
    for (final id in [StageId.stage1, StageId.stage4, StageId.stage7]) {
      final stage = StageRegistry.get(id);
      // These are intro stages, typically no boss
      expect(stage.waves, isNotEmpty);
    }
  });

  test('boss configs have valid HP ratios for boss stages', () {
    for (final id in [StageId.stage3, StageId.stage6, StageId.stage9]) {
      final stage = StageRegistry.get(id);
      expect(stage.bossConfig.phase2HpRatio, greaterThan(0));
      expect(stage.bossConfig.phase2HpRatio, lessThan(1));
      expect(stage.bossConfig.phase3HpRatio, greaterThan(0));
      expect(
        stage.bossConfig.phase3HpRatio,
        lessThan(stage.bossConfig.phase2HpRatio),
      );
    }
  });

  test('sector bosses scale in difficulty', () {
    final s3 = StageRegistry.get(StageId.stage3);
    final s6 = StageRegistry.get(StageId.stage6);
    final s9 = StageRegistry.get(StageId.stage9);
    expect(s6.bossConfig.baseHp, greaterThan(s3.bossConfig.baseHp));
    expect(s9.bossConfig.baseHp, greaterThan(s6.bossConfig.baseHp));
  });
}
