import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/persistence/key_value_store.dart';
import '../core/persistence/shared_prefs_store.dart';
import '../features/high_score/data/local_high_score_repository.dart';
import '../features/high_score/domain/high_score_repository.dart';
import '../features/settings/data/local_settings_repository.dart';
import '../features/settings/domain/game_settings.dart';
import '../features/settings/domain/settings_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden at startup');
});

final keyValueStoreProvider = Provider<KeyValueStore>((ref) {
  return SharedPrefsStore(ref.watch(sharedPreferencesProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return LocalSettingsRepository(ref.watch(keyValueStoreProvider));
});

final highScoreRepositoryProvider = Provider<HighScoreRepository>((ref) {
  return LocalHighScoreRepository(ref.watch(keyValueStoreProvider));
});

final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, GameSettings>((ref) {
      return GameSettingsNotifier(ref.watch(settingsRepositoryProvider));
    });

class GameSettingsNotifier extends StateNotifier<GameSettings> {
  final SettingsRepository _repository;

  GameSettingsNotifier(this._repository) : super(const GameSettings()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.load();
  }

  Future<void> update(GameSettings settings) async {
    state = settings;
    await _repository.save(settings);
  }
}

final bestScoreProvider = StateNotifierProvider<BestScoreNotifier, int>((ref) {
  return BestScoreNotifier(ref.watch(highScoreRepositoryProvider));
});

class BestScoreNotifier extends StateNotifier<int> {
  final HighScoreRepository _repository;

  BestScoreNotifier(this._repository) : super(0) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getBestScore();
  }

  Future<void> submit(int score) async {
    await _repository.saveBestScore(score);
    state = await _repository.getBestScore();
  }
}
