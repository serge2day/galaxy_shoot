abstract class ProgressionService {
  int getCurrentLevel();
  bool isLevelUnlocked(int level);
  Future<void> completeLevel(int level, int stars);
}
