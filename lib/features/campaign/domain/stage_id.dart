enum StageId {
  stage1,
  stage2,
  stage3;

  String get displayName {
    switch (this) {
      case StageId.stage1:
        return 'Frontier';
      case StageId.stage2:
        return 'Nebula';
      case StageId.stage3:
        return 'Dark Core';
    }
  }

  String get subtitle {
    switch (this) {
      case StageId.stage1:
        return 'The outer rim patrol';
      case StageId.stage2:
        return 'Through the storm';
      case StageId.stage3:
        return 'Final confrontation';
    }
  }

  int get stageIndex => index;

  StageId? get next {
    switch (this) {
      case StageId.stage1:
        return StageId.stage2;
      case StageId.stage2:
        return StageId.stage3;
      case StageId.stage3:
        return null;
    }
  }

  static StageId fromString(String value) {
    return StageId.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StageId.stage1,
    );
  }
}
