import '../../features/progression/domain/progression_repository.dart';

class SaveMigration {
  static const int currentVersion = 5;

  final ProgressionRepository _progression;

  SaveMigration(this._progression);

  Future<void> migrate() async {
    final version = await _progression.getSaveVersion();
    if (version >= currentVersion) return;

    // All migrations are additive - new keys default safely when absent.
    // v2: credits, upgrades, ships
    // v3: campaign, tutorial, stage scores, settings
    // v4: 9 stages, 6 ships, 5 enemy types, evolution
    // v5: endless galaxy mode (endless_unlocked, endless_highest_sector, etc)

    await _progression.setSaveVersion(currentVersion);
  }
}
