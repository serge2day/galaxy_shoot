import 'game_settings.dart';

abstract class SettingsRepository {
  Future<GameSettings> load();
  Future<void> save(GameSettings settings);
}
