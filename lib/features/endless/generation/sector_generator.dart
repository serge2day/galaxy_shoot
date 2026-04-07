import 'dart:math';

import '../domain/biome_definition.dart';
import '../domain/modifier_definition.dart';
import '../domain/sector_definition.dart';
import 'mission_generator.dart';

class SectorGenerator {
  /// Generates a sector from a seed and depth.
  static SectorDefinition generate({
    required int sectorNumber,
    required int seed,
  }) {
    final rng = Random(seed + sectorNumber * 7919);
    final depth = sectorNumber;

    // Pick biome based on depth
    final available = BiomeRegistry.availableAt(depth);
    final biome = available[rng.nextInt(available.length)];

    // Pick modifiers (0 at depth <2, 1 at 2-5, 2 at 6-10, 3 at 11+)
    final modCount = depth < 2
        ? 0
        : depth < 6
        ? 1
        : depth < 11
        ? 2
        : 3;
    final modifiers = _pickModifiers(rng, modCount);

    // Difficulty scaling
    final difficultyScale = 1.0 + depth * 0.12;

    // Mission count: 4-6, scales slightly with depth
    final int missionCount = 4 + min(depth ~/ 3, 2);

    // Generate missions
    final missions = MissionGenerator.generate(
      rng: rng,
      missionCount: missionCount,
      depth: depth,
      biome: biome,
    );

    // Boss stats scale with depth
    final bossHp = (200 + depth * 60).clamp(200, 2000).toInt();
    final bossFireRate = (0.5 - depth * 0.01).clamp(0.2, 0.5);

    return SectorDefinition(
      sectorNumber: sectorNumber,
      seed: seed,
      biome: biome.id,
      missions: missions,
      modifiers: modifiers,
      difficultyScale: difficultyScale,
      bossHp: bossHp,
      bossFireRate: bossFireRate,
    );
  }

  static List<ModifierId> _pickModifiers(Random rng, int count) {
    if (count <= 0) return [];
    final pool = List<ModifierId>.from(ModifierId.values);
    pool.shuffle(rng);
    return pool.take(count).toList();
  }
}
