import 'package:galaxy_shoot/core/persistence/key_value_store.dart';
import 'package:galaxy_shoot/features/hangar/domain/ship_catalog_repository.dart';
import 'package:galaxy_shoot/features/high_score/domain/high_score_repository.dart';
import 'package:galaxy_shoot/features/progression/domain/currency_wallet.dart';
import 'package:galaxy_shoot/features/progression/domain/progression_repository.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_state.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';
import 'package:galaxy_shoot/features/settings/domain/settings_repository.dart';

class InMemoryStore implements KeyValueStore {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;
  @override
  Future<String?> getString(String key) async => _data[key] as String?;
  @override
  Future<void> setInt(String key, int value) async => _data[key] = value;
  @override
  Future<int?> getInt(String key) async => _data[key] as int?;
  @override
  Future<void> remove(String key) async => _data.remove(key);
}

class FakeSettingsRepository implements SettingsRepository {
  GameSettings _settings = const GameSettings();

  @override
  Future<GameSettings> load() async => _settings;

  @override
  Future<void> save(GameSettings settings) async => _settings = settings;
}

class FakeHighScoreRepository implements HighScoreRepository {
  int _score;

  FakeHighScoreRepository([this._score = 0]);

  @override
  Future<int> getBestScore() async => _score;

  @override
  Future<void> saveBestScore(int score) async {
    if (score > _score) _score = score;
  }
}

class FakeProgressionRepository implements ProgressionRepository {
  CurrencyWallet _wallet = const CurrencyWallet();
  UpgradeState _upgrades = const UpgradeState();
  int _version = 2;

  @override
  Future<CurrencyWallet> getWallet() async => _wallet;

  @override
  Future<void> saveWallet(CurrencyWallet wallet) async => _wallet = wallet;

  @override
  Future<UpgradeState> getUpgradeState() async => _upgrades;

  @override
  Future<void> saveUpgradeState(UpgradeState state) async => _upgrades = state;

  @override
  Future<int> getSaveVersion() async => _version;

  @override
  Future<void> setSaveVersion(int version) async => _version = version;
}

class FakeShipCatalogRepository implements ShipCatalogRepository {
  final List<String> _unlocked = ['vanguard'];
  String _selected = 'vanguard';

  @override
  Future<List<String>> getUnlockedShipIds() async => List.from(_unlocked);

  @override
  Future<String> getSelectedShipId() async => _selected;

  @override
  Future<void> unlockShip(String shipId) async {
    if (!_unlocked.contains(shipId)) _unlocked.add(shipId);
  }

  @override
  Future<void> selectShip(String shipId) async => _selected = shipId;
}
