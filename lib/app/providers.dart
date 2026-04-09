import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/persistence/key_value_store.dart';
import '../core/persistence/shared_prefs_store.dart';
import '../core/services/game_audio.dart';
import '../core/services/game_haptics.dart';
import '../features/campaign/data/local_campaign_repository.dart';
import '../features/campaign/domain/campaign_repository.dart';
import '../features/campaign/domain/stage_id.dart';
import '../features/campaign/domain/stage_progress.dart';
import '../features/endless/data/local_endless_repository.dart';
import '../features/endless/domain/endless_progress.dart';
import '../features/hangar/data/local_ship_catalog_repository.dart';
import '../features/hangar/domain/ship_catalog_repository.dart';
import '../features/hangar/domain/ship_definition.dart';
import '../features/high_score/data/local_high_score_repository.dart';
import '../features/high_score/domain/high_score_repository.dart';
import '../features/progression/data/local_progression_repository.dart';
import '../features/progression/domain/currency_wallet.dart';
import '../features/progression/domain/progression_repository.dart';
import '../features/progression/domain/upgrade_state.dart';
import '../features/settings/data/local_settings_repository.dart';
import '../features/settings/domain/game_settings.dart';
import '../features/settings/domain/settings_repository.dart';

// --- Core ---

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden at startup');
});

final keyValueStoreProvider = Provider<KeyValueStore>((ref) {
  return SharedPrefsStore(ref.watch(sharedPreferencesProvider));
});

// --- Settings ---

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
    _applyAudioSettings(state);
  }

  Future<void> update(GameSettings settings) async {
    state = settings;
    await _repository.save(settings);
    _applyAudioSettings(settings);
  }

  void _applyAudioSettings(GameSettings settings) {
    GameAudio.instance.setMusicEnabled(settings.musicEnabled);
    GameAudio.instance.setSfxEnabled(settings.sfxEnabled);
    GameAudio.setMusicVolume(settings.musicVolume);
    GameAudio.setSfxVolume(settings.sfxVolume);
    GameHaptics.setEnabled(settings.hapticsEnabled);
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

// --- Progression ---

final progressionRepositoryProvider = Provider<ProgressionRepository>((ref) {
  return LocalProgressionRepository(ref.watch(keyValueStoreProvider));
});

final walletProvider = StateNotifierProvider<WalletNotifier, CurrencyWallet>((
  ref,
) {
  return WalletNotifier(ref.watch(progressionRepositoryProvider));
});

class WalletNotifier extends StateNotifier<CurrencyWallet> {
  final ProgressionRepository _repository;

  WalletNotifier(this._repository) : super(const CurrencyWallet()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getWallet();
  }

  Future<void> addCredits(int amount) async {
    state = state.add(amount);
    await _repository.saveWallet(state);
  }

  Future<bool> spend(int amount) async {
    if (!state.canAfford(amount)) return false;
    state = state.spend(amount);
    await _repository.saveWallet(state);
    return true;
  }
}

// --- Upgrades ---

final upgradeStateProvider =
    StateNotifierProvider<UpgradeStateNotifier, UpgradeState>((ref) {
      return UpgradeStateNotifier(ref.watch(progressionRepositoryProvider));
    });

class UpgradeStateNotifier extends StateNotifier<UpgradeState> {
  final ProgressionRepository _repository;

  UpgradeStateNotifier(this._repository) : super(const UpgradeState()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getUpgradeState();
  }

  Future<void> applyUpgrade(UpgradeState newState) async {
    state = newState;
    await _repository.saveUpgradeState(state);
  }
}

// --- Ships ---

final shipCatalogRepositoryProvider = Provider<ShipCatalogRepository>((ref) {
  return LocalShipCatalogRepository(ref.watch(keyValueStoreProvider));
});

final unlockedShipsProvider =
    StateNotifierProvider<UnlockedShipsNotifier, List<String>>((ref) {
      return UnlockedShipsNotifier(ref.watch(shipCatalogRepositoryProvider));
    });

class UnlockedShipsNotifier extends StateNotifier<List<String>> {
  final ShipCatalogRepository _repository;

  UnlockedShipsNotifier(this._repository) : super(['vanguard']) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getUnlockedShipIds();
  }

  Future<void> unlock(String shipId) async {
    await _repository.unlockShip(shipId);
    state = await _repository.getUnlockedShipIds();
  }
}

final selectedShipProvider =
    StateNotifierProvider<SelectedShipNotifier, String>((ref) {
      return SelectedShipNotifier(ref.watch(shipCatalogRepositoryProvider));
    });

class SelectedShipNotifier extends StateNotifier<String> {
  final ShipCatalogRepository _repository;

  SelectedShipNotifier(this._repository) : super('vanguard') {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getSelectedShipId();
  }

  Future<void> select(String shipId) async {
    await _repository.selectShip(shipId);
    state = shipId;
  }
}

final selectedShipDefinitionProvider = Provider<ShipDefinition>((ref) {
  final shipId = ref.watch(selectedShipProvider);
  return ShipCatalog.getById(shipId);
});

// --- Campaign ---

final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  return LocalCampaignRepository(ref.watch(keyValueStoreProvider));
});

final campaignProgressProvider =
    StateNotifierProvider<CampaignProgressNotifier, StageProgress>((ref) {
      return CampaignProgressNotifier(ref.watch(campaignRepositoryProvider));
    });

class CampaignProgressNotifier extends StateNotifier<StageProgress> {
  final CampaignRepository _repository;

  CampaignProgressNotifier(this._repository) : super(const StageProgress()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getProgress();
  }

  Future<void> clearStage(String stageIdName, int score) async {
    final stageId = _parseStageId(stageIdName);
    await _repository.clearStage(stageId, score);
    state = await _repository.getProgress();
  }

  Future<void> updateBestScore(String stageIdName, int score) async {
    final stageId = _parseStageId(stageIdName);
    await _repository.updateBestScore(stageId, score);
    state = await _repository.getProgress();
  }

  static StageId _parseStageId(String name) {
    return StageId.fromString(name);
  }
}

// --- Endless ---

final endlessRepositoryProvider = Provider<LocalEndlessRepository>((ref) {
  return LocalEndlessRepository(ref.watch(keyValueStoreProvider));
});

final endlessProgressProvider =
    StateNotifierProvider<EndlessProgressNotifier, EndlessProgress>((ref) {
      return EndlessProgressNotifier(ref.watch(endlessRepositoryProvider));
    });

class EndlessProgressNotifier extends StateNotifier<EndlessProgress> {
  final LocalEndlessRepository _repository;

  EndlessProgressNotifier(this._repository) : super(const EndlessProgress()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.load();
  }

  Future<void> unlock() async {
    state = state.copyWith(unlocked: true);
    await _repository.save(state);
  }

  Future<void> recordSectorCleared(int sector, int score, String shipId) async {
    state = state.withSectorCleared(sector, score, shipId);
    await _repository.save(state);
  }
}

// --- Reset Progress ---

final resetProgressProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final campaignRepo = ref.read(campaignRepositoryProvider);
    final progressionRepo = ref.read(progressionRepositoryProvider);
    final store = ref.read(keyValueStoreProvider);

    // Reset campaign
    await campaignRepo.resetAll();

    // Reset wallet
    await progressionRepo.saveWallet(const CurrencyWallet());

    // Reset upgrades
    await progressionRepo.saveUpgradeState(const UpgradeState());

    // Reset ships - clear and re-default
    await store.remove('unlocked_ships');
    await store.remove('selected_ship');

    // Reset high score
    await store.setInt('best_score', 0);

    // Reset endless
    await ref.read(endlessRepositoryProvider).reset();

    // Reload all providers
    ref.invalidate(endlessProgressProvider);
    ref.invalidate(walletProvider);
    ref.invalidate(upgradeStateProvider);
    ref.invalidate(unlockedShipsProvider);
    ref.invalidate(selectedShipProvider);
    ref.invalidate(campaignProgressProvider);
    ref.invalidate(bestScoreProvider);
  };
});
