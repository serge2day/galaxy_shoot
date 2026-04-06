import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_id.dart';
import 'package:galaxy_shoot/features/campaign/domain/stage_progress.dart';

void main() {
  test('stage 1 is always unlocked', () {
    const progress = StageProgress();
    expect(progress.isUnlocked(StageId.stage1), true);
  });

  test('stage 2 is locked until stage 1 is cleared', () {
    const progress = StageProgress();
    expect(progress.isUnlocked(StageId.stage2), false);

    final cleared = progress.withClear(StageId.stage1, 1000);
    expect(cleared.isUnlocked(StageId.stage2), true);
  });

  test('stage 3 is locked until stage 2 is cleared', () {
    var progress = const StageProgress();
    expect(progress.isUnlocked(StageId.stage3), false);

    progress = progress.withClear(StageId.stage1, 1000);
    expect(progress.isUnlocked(StageId.stage3), false);

    progress = progress.withClear(StageId.stage2, 2000);
    expect(progress.isUnlocked(StageId.stage3), true);
  });

  test('withClear marks stage as cleared', () {
    var progress = const StageProgress();
    expect(progress.isCleared(StageId.stage1), false);

    progress = progress.withClear(StageId.stage1, 500);
    expect(progress.isCleared(StageId.stage1), true);
  });

  test('withClear tracks best score', () {
    var progress = const StageProgress();
    progress = progress.withClear(StageId.stage1, 500);
    expect(progress.bestScoreFor(StageId.stage1), 500);

    progress = progress.withClear(StageId.stage1, 300);
    expect(progress.bestScoreFor(StageId.stage1), 500);

    progress = progress.withClear(StageId.stage1, 800);
    expect(progress.bestScoreFor(StageId.stage1), 800);
  });

  test('withBestScore only updates if higher', () {
    var progress = const StageProgress();
    progress = progress.withBestScore(StageId.stage1, 500);
    expect(progress.bestScoreFor(StageId.stage1), 500);

    progress = progress.withBestScore(StageId.stage1, 200);
    expect(progress.bestScoreFor(StageId.stage1), 500);
  });

  test('best score defaults to 0 for unplayed stage', () {
    const progress = StageProgress();
    expect(progress.bestScoreFor(StageId.stage1), 0);
  });
}
