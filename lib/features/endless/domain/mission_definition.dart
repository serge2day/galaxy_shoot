enum MissionType {
  standardAssault,
  swarmRush,
  eliteHunt,
  survivalWave,
  hazardCorridor,
  minibossEncounter,
  bossMission;

  String get displayName {
    switch (this) {
      case MissionType.standardAssault:
        return 'Assault';
      case MissionType.swarmRush:
        return 'Swarm Rush';
      case MissionType.eliteHunt:
        return 'Elite Hunt';
      case MissionType.survivalWave:
        return 'Survival';
      case MissionType.hazardCorridor:
        return 'Hazard Run';
      case MissionType.minibossEncounter:
        return 'Miniboss';
      case MissionType.bossMission:
        return 'Boss Fight';
    }
  }

  bool get hasBoss =>
      this == MissionType.bossMission || this == MissionType.minibossEncounter;
}

class MissionDefinition {
  final int index;
  final MissionType type;
  final int waveCount;
  final double threatBudget;
  final bool isFinal;

  const MissionDefinition({
    required this.index,
    required this.type,
    required this.waveCount,
    required this.threatBudget,
    this.isFinal = false,
  });
}
