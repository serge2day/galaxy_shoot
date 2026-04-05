import '../../../core/persistence/key_value_store.dart';
import '../domain/currency_wallet.dart';
import '../domain/progression_repository.dart';
import '../domain/upgrade_state.dart';
import '../domain/upgrade_type.dart';

class LocalProgressionRepository implements ProgressionRepository {
  final KeyValueStore _store;

  static const String _creditsKey = 'credits';
  static const String _saveVersionKey = 'save_version';
  static const String _upgradePrefix = 'upgrade_';

  LocalProgressionRepository(this._store);

  @override
  Future<CurrencyWallet> getWallet() async {
    final credits = await _store.getInt(_creditsKey) ?? 0;
    return CurrencyWallet(credits: credits);
  }

  @override
  Future<void> saveWallet(CurrencyWallet wallet) async {
    await _store.setInt(_creditsKey, wallet.credits);
  }

  @override
  Future<UpgradeState> getUpgradeState() async {
    final Map<UpgradeType, int> levels = {};
    for (final type in UpgradeType.values) {
      final level = await _store.getInt('$_upgradePrefix${type.name}') ?? 0;
      if (level > 0) {
        levels[type] = level;
      }
    }
    return UpgradeState(levels: levels);
  }

  @override
  Future<void> saveUpgradeState(UpgradeState state) async {
    for (final type in UpgradeType.values) {
      await _store.setInt('$_upgradePrefix${type.name}', state.levelOf(type));
    }
  }

  @override
  Future<int> getSaveVersion() async {
    return await _store.getInt(_saveVersionKey) ?? 0;
  }

  @override
  Future<void> setSaveVersion(int version) async {
    await _store.setInt(_saveVersionKey, version);
  }
}
