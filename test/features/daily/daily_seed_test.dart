import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/daily/domain/daily_seed.dart';

void main() {
  group('DailySeed.forDate', () {
    test('is deterministic for the same date', () {
      final d1 = DateTime(2026, 4, 10, 8, 15);
      final d2 = DateTime(2026, 4, 10, 23, 59);
      expect(DailySeed.forDate(d1), DailySeed.forDate(d2));
    });

    test('differs for different dates', () {
      final a = DailySeed.forDate(DateTime(2026, 4, 10));
      final b = DailySeed.forDate(DateTime(2026, 4, 11));
      expect(a, isNot(b));
    });

    test('matches yyyyMMdd formula', () {
      expect(DailySeed.forDate(DateTime(2026, 4, 10)), 20260410);
      expect(DailySeed.forDate(DateTime(2026, 12, 31)), 20261231);
      expect(DailySeed.forDate(DateTime(2027, 1, 1)), 20270101);
    });
  });

  group('DailySeed.dateKey', () {
    test('zero-pads month and day', () {
      expect(DailySeed.dateKey(DateTime(2026, 4, 1)), '2026-04-01');
      expect(DailySeed.dateKey(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('parseDateKey round-trips', () {
      final original = DateTime(2026, 7, 4);
      final parsed = DailySeed.parseDateKey(DailySeed.dateKey(original));
      expect(parsed, original);
    });

    test('parseDateKey returns null for garbage', () {
      expect(DailySeed.parseDateKey(''), isNull);
      expect(DailySeed.parseDateKey('bad'), isNull);
      expect(DailySeed.parseDateKey('2026-x-01'), isNull);
    });
  });

  group('DailySeed.daysBetween', () {
    test('ignores time-of-day', () {
      final a = DateTime(2026, 4, 10, 23, 59);
      final b = DateTime(2026, 4, 11, 0, 0);
      expect(DailySeed.daysBetween(a, b), 1);
    });

    test('handles multi-day gaps', () {
      expect(
        DailySeed.daysBetween(DateTime(2026, 4, 10), DateTime(2026, 4, 15)),
        5,
      );
    });

    test('zero for same day', () {
      expect(
        DailySeed.daysBetween(
          DateTime(2026, 4, 10, 8),
          DateTime(2026, 4, 10, 20),
        ),
        0,
      );
    });
  });
}
