class DailySeed {
  const DailySeed._();

  static int forDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return local.year * 10000 + local.month * 100 + local.day;
  }

  static String dateKey(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '${local.year}-$m-$d';
  }

  static DateTime? parseDateKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final a = DateTime(from.year, from.month, from.day);
    final b = DateTime(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }
}
