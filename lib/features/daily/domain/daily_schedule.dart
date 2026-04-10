class DailySchedule {
  const DailySchedule._();

  static const List<String> _weekdayShips = [
    'vanguard',  // Mon (DateTime.monday = 1)
    'striker',   // Tue
    'guardian',  // Wed
    'ravager',   // Thu
    'phantom',   // Fri
    'titan',     // Sat
    'vanguard',  // Sun
  ];

  static String shipIdForDate(DateTime date) {
    final weekday = date.weekday;
    return _weekdayShips[weekday - 1];
  }
}
