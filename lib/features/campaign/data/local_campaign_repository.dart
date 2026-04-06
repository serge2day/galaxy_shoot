import '../../../core/persistence/key_value_store.dart';
import '../domain/campaign_repository.dart';
import '../domain/stage_id.dart';
import '../domain/stage_progress.dart';

class LocalCampaignRepository implements CampaignRepository {
  final KeyValueStore _store;

  static const String _clearedPrefix = 'stage_cleared_';
  static const String _bestScorePrefix = 'stage_best_';
  static const String _tutorialKey = 'tutorial_completed';

  LocalCampaignRepository(this._store);

  @override
  Future<StageProgress> getProgress() async {
    final cleared = <StageId>{};
    final bestScores = <StageId, int>{};

    for (final stage in StageId.values) {
      final isCleared = await _store.getString('$_clearedPrefix${stage.name}');
      if (isCleared == 'true') {
        cleared.add(stage);
      }
      final score = await _store.getInt('$_bestScorePrefix${stage.name}');
      if (score != null && score > 0) {
        bestScores[stage] = score;
      }
    }

    return StageProgress(clearedStages: cleared, bestScores: bestScores);
  }

  @override
  Future<void> clearStage(StageId stage, int score) async {
    await _store.setString('$_clearedPrefix${stage.name}', 'true');
    final current = await _store.getInt('$_bestScorePrefix${stage.name}') ?? 0;
    if (score > current) {
      await _store.setInt('$_bestScorePrefix${stage.name}', score);
    }
  }

  @override
  Future<void> updateBestScore(StageId stage, int score) async {
    final current = await _store.getInt('$_bestScorePrefix${stage.name}') ?? 0;
    if (score > current) {
      await _store.setInt('$_bestScorePrefix${stage.name}', score);
    }
  }

  @override
  Future<bool> isTutorialCompleted() async {
    final val = await _store.getString(_tutorialKey);
    return val == 'true';
  }

  @override
  Future<void> setTutorialCompleted() async {
    await _store.setString(_tutorialKey, 'true');
  }

  @override
  Future<void> resetAll() async {
    for (final stage in StageId.values) {
      await _store.remove('$_clearedPrefix${stage.name}');
      await _store.remove('$_bestScorePrefix${stage.name}');
    }
    await _store.remove(_tutorialKey);
  }
}
