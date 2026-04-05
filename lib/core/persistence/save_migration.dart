import '../../features/progression/domain/progression_repository.dart';

class SaveMigration {
  static const int currentVersion = 2;

  final ProgressionRepository _progression;

  SaveMigration(this._progression);

  Future<void> migrate() async {
    final version = await _progression.getSaveVersion();
    if (version >= currentVersion) return;

    if (version < 2) {
      // Migration from Phase 1 (version 0 or 1) to Phase 2 (version 2):
      // - Phase 1 best_score and fire_mode are preserved as-is in their
      //   existing keys since those repositories haven't changed.
      // - Phase 2 adds new keys for credits, upgrades, ships.
      //   These default to zero/empty when absent, so no data copy needed.
      await _progression.setSaveVersion(2);
    }
  }
}
