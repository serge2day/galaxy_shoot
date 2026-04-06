import '../../features/progression/domain/progression_repository.dart';

class SaveMigration {
  static const int currentVersion = 3;

  final ProgressionRepository _progression;

  SaveMigration(this._progression);

  Future<void> migrate() async {
    final version = await _progression.getSaveVersion();
    if (version >= currentVersion) return;

    if (version < 2) {
      // Phase 1 -> Phase 2: new keys for credits, upgrades, ships default to
      // zero/empty. Phase 1 best_score and fire_mode preserved as-is.
    }

    if (version < 3) {
      // Phase 2 -> Phase 3: new keys for campaign progress, tutorial state,
      // per-stage best scores, and extended settings (music/sfx/haptics)
      // all default safely when absent. No data copy needed.
    }

    await _progression.setSaveVersion(currentVersion);
  }
}
