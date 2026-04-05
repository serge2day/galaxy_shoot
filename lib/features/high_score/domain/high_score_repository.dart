abstract class HighScoreRepository {
  Future<int> getBestScore();
  Future<void> saveBestScore(int score);
}
