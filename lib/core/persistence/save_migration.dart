import '../../features/progression/domain/progression_repository.dart';

class SaveMigration {
  static const int currentVersion = 4;

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
      // Phase 2 -> Phase 3: campaign progress, tutorial, per-stage scores,
      // extended settings. All default safely when absent.
    }

    if (version < 4) {
      // Phase 3 -> Evolution update: 9 stages (up from 3), 6 ships (up from 3),
      // 5 enemy types, evolution system. New keys default safely.
      // Existing stage clears for stage1-3 are preserved.
    }

    await _progression.setSaveVersion(currentVersion);
  }
}
