import 'upgrade_type.dart';

class UpgradeState {
  final Map<UpgradeType, int> levels;

  const UpgradeState({this.levels = const {}});

  int levelOf(UpgradeType type) => levels[type] ?? 0;

  UpgradeState withUpgrade(UpgradeType type, int level) {
    return UpgradeState(levels: {...levels, type: level});
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpgradeState &&
          runtimeType == other.runtimeType &&
          _mapsEqual(levels, other.levels);

  @override
  int get hashCode =>
      Object.hashAll(levels.entries.map((e) => Object.hash(e.key, e.value)));

  static bool _mapsEqual(Map<UpgradeType, int> a, Map<UpgradeType, int> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
