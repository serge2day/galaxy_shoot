import '../../../core/config/game_constants.dart';
import '../../../core/persistence/key_value_store.dart';
import '../domain/high_score_repository.dart';

class LocalHighScoreRepository implements HighScoreRepository {
  final KeyValueStore _store;

  LocalHighScoreRepository(this._store);

  @override
  Future<int> getBestScore() async {
    return await _store.getInt(GameConstants.bestScoreKey) ?? 0;
  }

  @override
  Future<void> saveBestScore(int score) async {
    final current = await getBestScore();
    if (score > current) {
      await _store.setInt(GameConstants.bestScoreKey, score);
    }
  }
}
