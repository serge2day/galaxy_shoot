import 'daily_seed.dart';

class DailyResult {
  final String? lastPlayedDate;
  final int lastScore;
  final int lastMissionsCleared;
  final int lastMissionCount;
  final bool lastCleared;
  final int currentStreak;
  final int bestStreak;
  final int allTimeBestScore;
  final String? allTimeBestDate;

  const DailyResult({
    this.lastPlayedDate,
    this.lastScore = 0,
    this.lastMissionsCleared = 0,
    this.lastMissionCount = 0,
    this.lastCleared = false,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.allTimeBestScore = 0,
    this.allTimeBestDate,
  });

  bool playedOn(DateTime date) =>
      lastPlayedDate != null && lastPlayedDate == DailySeed.dateKey(date);

  DailyResult withRun({
    required DateTime playDate,
    required int score,
    required int missionsCleared,
    required int missionCount,
    required bool cleared,
  }) {
    final playedKey = DailySeed.dateKey(playDate);
    int newStreak;
    if (lastPlayedDate == null) {
      newStreak = 1;
    } else {
      final prev = DailySeed.parseDateKey(lastPlayedDate!);
      if (prev == null) {
        newStreak = 1;
      } else {
        final gap = DailySeed.daysBetween(prev, playDate);
        if (gap == 0) {
          newStreak = currentStreak == 0 ? 1 : currentStreak;
        } else if (gap == 1) {
          newStreak = currentStreak + 1;
        } else {
          newStreak = 1;
        }
      }
    }

    final newBestStreak = newStreak > bestStreak ? newStreak : bestStreak;
    final beatsAllTime = score > allTimeBestScore;

    return DailyResult(
      lastPlayedDate: playedKey,
      lastScore: score,
      lastMissionsCleared: missionsCleared,
      lastMissionCount: missionCount,
      lastCleared: cleared,
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      allTimeBestScore: beatsAllTime ? score : allTimeBestScore,
      allTimeBestDate: beatsAllTime ? playedKey : allTimeBestDate,
    );
  }
}
