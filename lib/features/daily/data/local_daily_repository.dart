import '../../../core/persistence/key_value_store.dart';
import '../domain/daily_result.dart';

class LocalDailyRepository {
  final KeyValueStore _store;

  static const String _lastDateKey = 'daily_last_date';
  static const String _lastScoreKey = 'daily_last_score';
  static const String _lastMissionsKey = 'daily_last_missions';
  static const String _lastMissionCountKey = 'daily_last_mission_count';
  static const String _lastClearedKey = 'daily_last_cleared';
  static const String _currentStreakKey = 'daily_current_streak';
  static const String _bestStreakKey = 'daily_best_streak';
  static const String _allTimeBestKey = 'daily_all_time_best';
  static const String _allTimeBestDateKey = 'daily_all_time_best_date';

  LocalDailyRepository(this._store);

  Future<DailyResult> load() async {
    return DailyResult(
      lastPlayedDate: await _store.getString(_lastDateKey),
      lastScore: await _store.getInt(_lastScoreKey) ?? 0,
      lastMissionsCleared: await _store.getInt(_lastMissionsKey) ?? 0,
      lastMissionCount: await _store.getInt(_lastMissionCountKey) ?? 0,
      lastCleared: (await _store.getString(_lastClearedKey)) == 'true',
      currentStreak: await _store.getInt(_currentStreakKey) ?? 0,
      bestStreak: await _store.getInt(_bestStreakKey) ?? 0,
      allTimeBestScore: await _store.getInt(_allTimeBestKey) ?? 0,
      allTimeBestDate: await _store.getString(_allTimeBestDateKey),
    );
  }

  Future<void> save(DailyResult result) async {
    if (result.lastPlayedDate != null) {
      await _store.setString(_lastDateKey, result.lastPlayedDate!);
    }
    await _store.setInt(_lastScoreKey, result.lastScore);
    await _store.setInt(_lastMissionsKey, result.lastMissionsCleared);
    await _store.setInt(_lastMissionCountKey, result.lastMissionCount);
    await _store.setString(_lastClearedKey, result.lastCleared.toString());
    await _store.setInt(_currentStreakKey, result.currentStreak);
    await _store.setInt(_bestStreakKey, result.bestStreak);
    await _store.setInt(_allTimeBestKey, result.allTimeBestScore);
    if (result.allTimeBestDate != null) {
      await _store.setString(_allTimeBestDateKey, result.allTimeBestDate!);
    }
  }

  Future<void> reset() async {
    await _store.remove(_lastDateKey);
    await _store.remove(_lastScoreKey);
    await _store.remove(_lastMissionsKey);
    await _store.remove(_lastMissionCountKey);
    await _store.remove(_lastClearedKey);
    await _store.remove(_currentStreakKey);
    await _store.remove(_bestStreakKey);
    await _store.remove(_allTimeBestKey);
    await _store.remove(_allTimeBestDateKey);
  }
}
