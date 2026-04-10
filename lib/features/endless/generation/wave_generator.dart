import 'dart:math';

import '../../../game/components/enemies/enemy_type.dart';
import '../../../game/world/stages/stage_definition.dart';
import '../domain/biome_definition.dart';
import '../domain/mission_definition.dart';
import '../domain/modifier_definition.dart';
import '../domain/wave_template.dart';

class GeneratedWave {
  final double time;
  final int count;
  final EnemyType enemyType;
  final EnemyMovementType movement;
  final bool isElite;

  const GeneratedWave({
    required this.time,
    required this.count,
    required this.enemyType,
    required this.movement,
    this.isElite = false,
  });
}

class WaveGenerator {
  static const _movements = EnemyMovementType.values;

  static List<GeneratedWave> generate({
    required Random rng,
    required MissionDefinition mission,
    required BiomeDefinition biome,
    required double difficultyScale,
    required ModifierEffect modifiers,
    int missionIndex = 0,
  }) {
    // Per-mission progression ramp inside a sector: each mission gets
    // ~15% more enemies and an extra wave every 2 missions in.
    final missionRamp = 1.0 + missionIndex * 0.15;
    final extraWaves = missionIndex ~/ 2;

    final waves = <GeneratedWave>[];
    var remainingBudget = mission.threatBudget * difficultyScale * missionRamp;
    final waveCount = mission.waveCount + extraWaves;

    // Pick wave patterns
    final patterns = _selectPatterns(rng, waveCount, mission.type);

    double time = 2.0;
    for (int i = 0; i < patterns.length && remainingBudget > 0; i++) {
      final pattern = patterns[i];
      final cost = pattern.baseThreatCost * difficultyScale;
      remainingBudget -= cost;

      // Enemy type: prefer pattern preference but mix from biome pool
      final enemyType = _pickEnemy(rng, pattern, biome);

      // Count scaled by modifiers + per-mission ramp
      var count = (pattern.baseCount * modifiers.enemyCountScale * missionRamp)
          .round();
      count = (count * (0.8 + difficultyScale * 0.2)).round().clamp(2, 30);

      // Elite chance
      final isElite =
          rng.nextDouble() <
          biome.eliteChance * modifiers.eliteScale * difficultyScale * 0.5;

      waves.add(
        GeneratedWave(
          time: time,
          count: count,
          enemyType: enemyType,
          movement: _movements[rng.nextInt(_movements.length)],
          isElite: isElite,
        ),
      );

      time += 3.5 + rng.nextDouble() * 2.5;
    }

    return waves;
  }

  static List<WavePatternId> _selectPatterns(
    Random rng,
    int count,
    MissionType type,
  ) {
    final pool = <WavePatternId>[];

    switch (type) {
      case MissionType.swarmRush:
        pool.addAll([
          WavePatternId.swarmerFlood,
          WavePatternId.swarmerFlood,
          WavePatternId.laneAssault,
          WavePatternId.diagonalRain,
          WavePatternId.staggeredDescent,
        ]);
        break;
      case MissionType.eliteHunt:
        pool.addAll([
          WavePatternId.eliteEscort,
          WavePatternId.eliteEscort,
          WavePatternId.heavyAnchor,
          WavePatternId.interceptorSweep,
          WavePatternId.pincerEntry,
        ]);
        break;
      case MissionType.hazardCorridor:
        pool.addAll([
          WavePatternId.laneAssault,
          WavePatternId.diagonalRain,
          WavePatternId.staggeredDescent,
        ]);
        break;
      case MissionType.minibossEncounter:
        pool.addAll([
          WavePatternId.minibossPrelude,
          WavePatternId.interceptorSweep,
          WavePatternId.heavyAnchor,
          WavePatternId.pincerEntry,
          WavePatternId.laneAssault,
        ]);
        break;
      case MissionType.bossMission:
        pool.addAll([
          WavePatternId.bossPrelude,
          WavePatternId.interceptorSweep,
          WavePatternId.swarmerFlood,
          WavePatternId.heavyAnchor,
          WavePatternId.eliteEscort,
          WavePatternId.pincerEntry,
        ]);
        break;
      default:
        pool.addAll(WavePatternId.values);
        break;
    }

    final result = <WavePatternId>[];
    for (int i = 0; i < count; i++) {
      result.add(pool[rng.nextInt(pool.length)]);
    }
    return result;
  }

  static EnemyType _pickEnemy(
    Random rng,
    WavePatternId pattern,
    BiomeDefinition biome,
  ) {
    // 60% chance use pattern preference, 40% from biome pool
    if (rng.nextDouble() < 0.6) {
      return _enemyFromName(pattern.preferredEnemy);
    }
    final pool = biome.enemyWeights;
    return _enemyFromName(pool[rng.nextInt(pool.length)]);
  }

  static EnemyType _enemyFromName(String name) {
    switch (name) {
      case 'drone':
        return EnemyType.drone;
      case 'interceptor':
        return EnemyType.interceptor;
      case 'gunship':
        return EnemyType.gunship;
      case 'swarmer':
        return EnemyType.swarmer;
      case 'carrier':
        return EnemyType.carrier;
      default:
        return EnemyType.drone;
    }
  }
}
