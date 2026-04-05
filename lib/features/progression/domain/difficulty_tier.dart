enum DifficultyTier {
  normal,
  veteran,
  expert;

  String get displayName {
    switch (this) {
      case DifficultyTier.normal:
        return 'Normal';
      case DifficultyTier.veteran:
        return 'Veteran';
      case DifficultyTier.expert:
        return 'Expert';
    }
  }

  String get description {
    switch (this) {
      case DifficultyTier.normal:
        return 'Standard challenge.';
      case DifficultyTier.veteran:
        return 'Tougher enemies, better rewards.';
      case DifficultyTier.expert:
        return 'Maximum challenge and rewards.';
    }
  }

  static DifficultyTier fromString(String value) {
    return DifficultyTier.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DifficultyTier.normal,
    );
  }
}
