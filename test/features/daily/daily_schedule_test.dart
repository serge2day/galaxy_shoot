import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/daily/domain/daily_schedule.dart';

void main() {
  group('DailySchedule.shipIdForDate', () {
    test('rotates through the weekday map', () {
      // 2026-04-06 is a Monday
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 6)), 'vanguard');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 7)), 'striker');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 8)), 'guardian');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 9)), 'ravager');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 10)), 'phantom');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 11)), 'titan');
      expect(DailySchedule.shipIdForDate(DateTime(2026, 4, 12)), 'vanguard');
    });

    test('same weekday always maps to same ship', () {
      expect(
        DailySchedule.shipIdForDate(DateTime(2026, 4, 6)),
        DailySchedule.shipIdForDate(DateTime(2026, 4, 13)),
      );
    });
  });
}
