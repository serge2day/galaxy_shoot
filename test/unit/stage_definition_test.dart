import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_id.dart';
import 'package:galaxy_shoot/game/world/stages/stage_01.dart';
import 'package:galaxy_shoot/game/world/stages/stage_02.dart';
import 'package:galaxy_shoot/game/world/stages/stage_03.dart';
import 'package:galaxy_shoot/game/world/stages/stage_registry.dart';

void main() {
  test('stage registry returns all 3 stages', () {
    for (final id in StageId.values) {
      final stage = StageRegistry.get(id);
      expect(stage.id, id);
      expect(stage.waves, isNotEmpty);
      expect(stage.bossSpawnTime, greaterThan(0));
    }
  });

  test('each stage has waves before boss spawn', () {
    for (final id in StageId.values) {
      final stage = StageRegistry.get(id);
      for (final wave in stage.waves) {
        expect(wave.time, lessThan(stage.bossSpawnTime));
      }
    }
  });

  test('stage difficulty scales across stages', () {
    expect(stage02.bossConfig.baseHp, greaterThan(stage01.bossConfig.baseHp));
    expect(stage03.bossConfig.baseHp, greaterThan(stage02.bossConfig.baseHp));
  });

  test('stage 3 has more waves than stage 1', () {
    expect(stage03.waves.length, greaterThan(stage01.waves.length));
  });

  test('boss configs have valid HP ratios', () {
    for (final id in StageId.values) {
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
}
