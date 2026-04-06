import 'stage_id.dart';

class StageProgress {
  final Set<StageId> clearedStages;
  final Map<StageId, int> bestScores;

  const StageProgress({
    this.clearedStages = const {},
    this.bestScores = const {},
  });

  bool isUnlocked(StageId stage) {
    if (stage == StageId.stage1) return true;
    // Previous stage must be cleared
    final prevIndex = stage.index - 1;
    final prev = StageId.values[prevIndex];
    return clearedStages.contains(prev);
  }

  bool isCleared(StageId stage) => clearedStages.contains(stage);

  int bestScoreFor(StageId stage) => bestScores[stage] ?? 0;

  StageProgress withClear(StageId stage, int score) {
    final newCleared = {...clearedStages, stage};
    final currentBest = bestScores[stage] ?? 0;
    final newBests = {
      ...bestScores,
      stage: score > currentBest ? score : currentBest,
    };
    return StageProgress(clearedStages: newCleared, bestScores: newBests);
  }

  StageProgress withBestScore(StageId stage, int score) {
    final currentBest = bestScores[stage] ?? 0;
    if (score <= currentBest) return this;
    return StageProgress(
      clearedStages: clearedStages,
      bestScores: {...bestScores, stage: score},
    );
  }
}
