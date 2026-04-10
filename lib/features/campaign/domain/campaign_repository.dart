import 'stage_id.dart';
import 'stage_progress.dart';

abstract class CampaignRepository {
  Future<StageProgress> getProgress();
  Future<void> clearStage(StageId stage, int score);
  Future<void> updateBestScore(StageId stage, int score);
  Future<bool> isTutorialCompleted();
  Future<void> setTutorialCompleted();
  Future<void> resetTutorial();
  Future<void> resetAll();
}
