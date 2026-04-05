import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/persistence/key_value_store.dart';
import 'package:galaxy_shoot/features/settings/data/local_settings_repository.dart';
import 'package:galaxy_shoot/features/settings/domain/fire_mode.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';

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

void main() {
  late InMemoryStore store;
  late LocalSettingsRepository repo;

  setUp(() {
    store = InMemoryStore();
    repo = LocalSettingsRepository(store);
  });

  test('loads default settings when store is empty', () async {
    final settings = await repo.load();
    expect(settings.fireMode, FireMode.auto);
  });

  test('saves and loads fire mode correctly', () async {
    await repo.save(const GameSettings(fireMode: FireMode.manual));
    final loaded = await repo.load();
    expect(loaded.fireMode, FireMode.manual);
  });

  test('overwrites previous setting', () async {
    await repo.save(const GameSettings(fireMode: FireMode.manual));
    await repo.save(const GameSettings(fireMode: FireMode.auto));
    final loaded = await repo.load();
    expect(loaded.fireMode, FireMode.auto);
  });
}
