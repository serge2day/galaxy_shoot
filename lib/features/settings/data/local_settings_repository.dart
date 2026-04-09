import '../../../core/persistence/key_value_store.dart';
import '../domain/fire_mode.dart';
import '../domain/game_settings.dart';
import '../domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  final KeyValueStore _store;

  static const String _fireModeKey = 'fire_mode';
  static const String _musicKey = 'music_enabled';
  static const String _sfxKey = 'sfx_enabled';
  static const String _hapticsKey = 'haptics_enabled';
  static const String _musicVolumeKey = 'music_volume';
  static const String _sfxVolumeKey = 'sfx_volume';

  LocalSettingsRepository(this._store);

  @override
  Future<GameSettings> load() async {
    final fireModeStr = await _store.getString(_fireModeKey);
    final fireMode = fireModeStr != null
        ? FireMode.fromString(fireModeStr)
        : FireMode.auto;
    final music = await _store.getString(_musicKey);
    final sfx = await _store.getString(_sfxKey);
    final haptics = await _store.getString(_hapticsKey);
    final musicVol = await _store.getString(_musicVolumeKey);
    final sfxVol = await _store.getString(_sfxVolumeKey);
    return GameSettings(
      fireMode: fireMode,
      musicEnabled: music != 'false',
      sfxEnabled: sfx != 'false',
      hapticsEnabled: haptics != 'false',
      musicVolume: musicVol != null ? double.tryParse(musicVol) ?? 0.5 : 0.5,
      sfxVolume: sfxVol != null ? double.tryParse(sfxVol) ?? 0.5 : 0.5,
    );
  }

  @override
  Future<void> save(GameSettings settings) async {
    await _store.setString(_fireModeKey, settings.fireMode.name);
    await _store.setString(_musicKey, settings.musicEnabled.toString());
    await _store.setString(_sfxKey, settings.sfxEnabled.toString());
    await _store.setString(_hapticsKey, settings.hapticsEnabled.toString());
    await _store.setString(
      _musicVolumeKey,
      settings.musicVolume.toStringAsFixed(2),
    );
    await _store.setString(
      _sfxVolumeKey,
      settings.sfxVolume.toStringAsFixed(2),
    );
  }
}
