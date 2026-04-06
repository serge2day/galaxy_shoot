enum StageId {
  stage1,
  stage2,
  stage3,
  stage4,
  stage5,
  stage6,
  stage7,
  stage8,
  stage9;

  String get displayName {
    switch (this) {
      case StageId.stage1:
        return 'Frontier';
      case StageId.stage2:
        return 'Patrol';
      case StageId.stage3:
        return 'Warden';
      case StageId.stage4:
        return 'Nebula';
      case StageId.stage5:
        return 'Storm';
      case StageId.stage6:
        return 'Abyss';
      case StageId.stage7:
        return 'Ember';
      case StageId.stage8:
        return 'Siege';
      case StageId.stage9:
        return 'Dark Core';
    }
  }

  String get subtitle {
    switch (this) {
      case StageId.stage1:
        return 'The outer rim patrol';
      case StageId.stage2:
        return 'Sweep the perimeter';
      case StageId.stage3:
        return 'Guardian of the gate';
      case StageId.stage4:
        return 'Into the nebula';
      case StageId.stage5:
        return 'Through the storm';
      case StageId.stage6:
        return 'Depths of the void';
      case StageId.stage7:
        return 'Flames of war';
      case StageId.stage8:
        return 'Breach the fortress';
      case StageId.stage9:
        return 'Final confrontation';
    }
  }

  int get stageIndex => index;

  StageId? get next {
    final i = index + 1;
    if (i < StageId.values.length) {
      return StageId.values[i];
    }
    return null;
  }

  static StageId fromString(String value) {
    return StageId.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StageId.stage1,
    );
  }
}
