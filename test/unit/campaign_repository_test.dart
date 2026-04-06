import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/campaign/data/local_campaign_repository.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_id.dart';

import '../helpers/test_helpers.dart';

void main() {
  late InMemoryStore store;
  late LocalCampaignRepository repo;

  setUp(() {
    store = InMemoryStore();
    repo = LocalCampaignRepository(store);
  });

  test('initial progress has no cleared stages', () async {
    final progress = await repo.getProgress();
    expect(progress.isCleared(StageId.stage1), false);
    expect(progress.isCleared(StageId.stage2), false);
  });

  test('clearStage persists', () async {
    await repo.clearStage(StageId.stage1, 1000);
    final progress = await repo.getProgress();
    expect(progress.isCleared(StageId.stage1), true);
    expect(progress.bestScoreFor(StageId.stage1), 1000);
  });

  test('updateBestScore only saves if higher', () async {
    await repo.updateBestScore(StageId.stage1, 500);
    await repo.updateBestScore(StageId.stage1, 300);
    final progress = await repo.getProgress();
    expect(progress.bestScoreFor(StageId.stage1), 500);
  });

  test('tutorial defaults to not completed', () async {
    expect(await repo.isTutorialCompleted(), false);
  });

  test('tutorial completion persists', () async {
    await repo.setTutorialCompleted();
    expect(await repo.isTutorialCompleted(), true);
  });

  test('resetAll clears everything', () async {
    await repo.clearStage(StageId.stage1, 1000);
    await repo.setTutorialCompleted();
    await repo.resetAll();
    final progress = await repo.getProgress();
    expect(progress.isCleared(StageId.stage1), false);
    expect(await repo.isTutorialCompleted(), false);
  });
}
