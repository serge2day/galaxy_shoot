import '../../../core/config/game_constants.dart';
import '../../../core/persistence/key_value_store.dart';
import '../domain/fire_mode.dart';
import '../domain/game_settings.dart';
import '../domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  final KeyValueStore _store;

  LocalSettingsRepository(this._store);

  @override
  Future<GameSettings> load() async {
    final fireModeStr = await _store.getString(GameConstants.fireModeKey);
    final fireMode = fireModeStr != null
        ? FireMode.fromString(fireModeStr)
        : FireMode.auto;
    return GameSettings(fireMode: fireMode);
  }

  @override
  Future<void> save(GameSettings settings) async {
    await _store.setString(GameConstants.fireModeKey, settings.fireMode.name);
  }
}
