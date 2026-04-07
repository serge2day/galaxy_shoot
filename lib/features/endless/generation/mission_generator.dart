import 'dart:math';

import '../domain/biome_definition.dart';
import '../domain/mission_definition.dart';

class MissionGenerator {
  static List<MissionDefinition> generate({
    required Random rng,
    required int missionCount,
    required int depth,
    required BiomeDefinition biome,
  }) {
    final missions = <MissionDefinition>[];
    final baseBudget = 60.0 + depth * 15;

    for (int i = 0; i < missionCount; i++) {
      final isFinal = i == missionCount - 1;
      final isPreFinal = i == missionCount - 2;

      MissionType type;
      if (isFinal) {
        type = MissionType.bossMission;
      } else if (isPreFinal) {
        type = MissionType.eliteHunt;
      } else if (i == missionCount ~/ 2 && depth > 2) {
        type = MissionType.minibossEncounter;
      } else {
        type = _pickStandardType(rng, i, biome);
      }

      final waveCount = _wavesForType(type, depth);
      final budget = _budgetForType(type, baseBudget);

      missions.add(
        MissionDefinition(
          index: i,
          type: type,
          waveCount: waveCount,
          threatBudget: budget,
          isFinal: isFinal,
        ),
      );
    }

    return missions;
  }

  static MissionType _pickStandardType(
    Random rng,
    int index,
    BiomeDefinition biome,
  ) {
    final pool = <MissionType>[
      MissionType.standardAssault,
      MissionType.standardAssault,
      MissionType.swarmRush,
      MissionType.survivalWave,
    ];
    if (biome.hazardDensity > 0.4) {
      pool.add(MissionType.hazardCorridor);
    }
    return pool[rng.nextInt(pool.length)];
  }

  static int _wavesForType(MissionType type, int depth) {
    switch (type) {
      case MissionType.standardAssault:
        return 5 + min(depth ~/ 3, 3);
      case MissionType.swarmRush:
        return 6 + min(depth ~/ 4, 3);
      case MissionType.eliteHunt:
        return 4 + min(depth ~/ 4, 2);
      case MissionType.survivalWave:
        return 7 + min(depth ~/ 3, 4);
      case MissionType.hazardCorridor:
        return 4 + min(depth ~/ 5, 2);
      case MissionType.minibossEncounter:
        return 5 + min(depth ~/ 4, 3);
      case MissionType.bossMission:
        return 6 + min(depth ~/ 3, 4);
    }
  }

  static double _budgetForType(MissionType type, double base) {
    switch (type) {
      case MissionType.standardAssault:
        return base;
      case MissionType.swarmRush:
        return base * 1.2;
      case MissionType.eliteHunt:
        return base * 1.3;
      case MissionType.survivalWave:
        return base * 1.1;
      case MissionType.hazardCorridor:
        return base * 0.8;
      case MissionType.minibossEncounter:
        return base * 1.4;
      case MissionType.bossMission:
        return base * 1.5;
    }
  }
}
