import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/daily/domain/daily_result.dart';

void main() {
  group('DailyResult.withRun — streaks', () {
    test('first run starts streak at 1', () {
      final r = const DailyResult().withRun(
        playDate: DateTime(2026, 4, 10),
        score: 1000,
        missionsCleared: 5,
        missionCount: 5,
        cleared: true,
      );
      expect(r.currentStreak, 1);
      expect(r.bestStreak, 1);
      expect(r.lastPlayedDate, '2026-04-10');
      expect(r.lastCleared, true);
      expect(r.allTimeBestScore, 1000);
      expect(r.allTimeBestDate, '2026-04-10');
    });

    test('consecutive days increment streak', () {
      var r = const DailyResult().withRun(
        playDate: DateTime(2026, 4, 10),
        score: 100,
        missionsCleared: 1,
        missionCount: 5,
        cleared: false,
      );
      r = r.withRun(
        playDate: DateTime(2026, 4, 11),
        score: 200,
        missionsCleared: 2,
        missionCount: 5,
        cleared: false,
      );
      r = r.withRun(
        playDate: DateTime(2026, 4, 12),
        score: 300,
        missionsCleared: 3,
        missionCount: 5,
        cleared: false,
      );
      expect(r.currentStreak, 3);
      expect(r.bestStreak, 3);
    });

    test('gap of 2+ days resets streak to 1', () {
      var r = const DailyResult().withRun(
        playDate: DateTime(2026, 4, 10),
        score: 100,
        missionsCleared: 1,
        missionCount: 5,
        cleared: false,
      );
      r = r.withRun(
        playDate: DateTime(2026, 4, 11),
        score: 200,
        missionsCleared: 2,
        missionCount: 5,
        cleared: false,
      );
      // Skip a day (Apr 12)
      r = r.withRun(
        playDate: DateTime(2026, 4, 13),
        score: 300,
        missionsCleared: 3,
        missionCount: 5,
        cleared: false,
      );
      expect(r.currentStreak, 1);
      expect(r.bestStreak, 2);
    });

    test('best streak is preserved across reset', () {
      var r = const DailyResult(currentStreak: 5, bestStreak: 5);
      r = r.withRun(
        playDate: DateTime(2026, 4, 10),
        score: 100,
        missionsCleared: 1,
        missionCount: 5,
        cleared: false,
      );
      expect(r.bestStreak, 5);
      expect(r.currentStreak, 1);
    });

    test('all-time best only updates when beaten', () {
      var r = const DailyResult().withRun(
        playDate: DateTime(2026, 4, 10),
        score: 5000,
        missionsCleared: 5,
        missionCount: 5,
        cleared: true,
      );
      r = r.withRun(
        playDate: DateTime(2026, 4, 11),
        score: 3000,
        missionsCleared: 3,
        missionCount: 5,
        cleared: false,
      );
      expect(r.allTimeBestScore, 5000);
      expect(r.allTimeBestDate, '2026-04-10');
      r = r.withRun(
        playDate: DateTime(2026, 4, 12),
        score: 7000,
        missionsCleared: 5,
        missionCount: 5,
        cleared: true,
      );
      expect(r.allTimeBestScore, 7000);
      expect(r.allTimeBestDate, '2026-04-12');
    });
  });

  group('DailyResult.playedOn', () {
    test('false for fresh result', () {
      expect(const DailyResult().playedOn(DateTime(2026, 4, 10)), false);
    });

    test('true on the same local day regardless of time', () {
      final r = const DailyResult().withRun(
        playDate: DateTime(2026, 4, 10, 9),
        score: 100,
        missionsCleared: 1,
        missionCount: 5,
        cleared: false,
      );
      expect(r.playedOn(DateTime(2026, 4, 10, 23)), true);
      expect(r.playedOn(DateTime(2026, 4, 11, 0)), false);
    });
  });
}
