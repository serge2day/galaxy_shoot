import 'biome_definition.dart';
import 'mission_definition.dart';
import 'modifier_definition.dart';

class SectorDefinition {
  final int sectorNumber;
  final int seed;
  final BiomeId biome;
  final List<MissionDefinition> missions;
  final List<ModifierId> modifiers;
  final double difficultyScale;
  final int bossHp;
  final double bossFireRate;

  const SectorDefinition({
    required this.sectorNumber,
    required this.seed,
    required this.biome,
    required this.missions,
    required this.modifiers,
    required this.difficultyScale,
    required this.bossHp,
    required this.bossFireRate,
  });

  int get missionCount => missions.length;

  String get displayName =>
      '${BiomeRegistry.getById(biome).id.displayName} #$sectorNumber';
}
