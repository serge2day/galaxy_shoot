import 'package:flame_audio/flame_audio.dart';

import 'audio_service.dart';

/// Audio service using a fixed pool of AudioPlayers to prevent memory leaks.
/// FlameAudio.play() creates new players every call - this reuses them.
class FlameAudioService implements AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;
  double _musicVolume = 0.25;
  double _sfxVolume = 0.35;
  bool _paused = false;

  // Fixed pool of reusable audio players
  static const int _poolSize = 6;
  final List<AudioPlayer> _pool = [];
  int _nextPlayer = 0;

  // Throttle
  final Map<String, DateTime> _lastPlayed = {};
  static const Duration _sfxThrottle = Duration(milliseconds: 200);
  static const Duration _fireThrottle = Duration(milliseconds: 500);

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  @override
  Future<void> initialize() async {
    try {
      // Create reusable player pool
      for (int i = 0; i < _poolSize; i++) {
        final player = AudioPlayer();
        await player.setPlayerMode(PlayerMode.lowLatency);
        _pool.add(player);
      }

      // Pre-cache audio files
      await FlameAudio.audioCache.loadAll([
        'player_fire.mp3',
        'enemy_hit.mp3',
        'enemy_death.mp3',
        'player_damage.mp3',
        'player_death.mp3',
        'pickup_collect.mp3',
        'evolution_up.mp3',
        'boss_enter.mp3',
        'boss_phase.mp3',
        'boss_death.mp3',
        'victory.mp3',
        'game_over.mp3',
      ]);
      _initialized = true;
    } catch (e) {
      _initialized = false;
    }
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) stopBgm();
  }

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }

  void pauseAll() {
    _paused = true;
    try {
      FlameAudio.bgm.pause();
      for (final player in _pool) {
        player.stop();
      }
    } catch (e) {
      // ignore
    }
  }

  void resumeAll() {
    _paused = false;
    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      // ignore
    }
  }

  @override
  void playBgm(String track) {
    if (!_musicEnabled || !_initialized || _paused) return;
    try {
      FlameAudio.bgm.play(track, volume: _musicVolume);
    } catch (e) {
      // Graceful fallback
    }
  }

  @override
  void stopBgm() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      // Graceful fallback
    }
  }

  @override
  void playSfx(String effect) {
    if (!_sfxEnabled || !_initialized || _paused) return;

    // Throttle
    final now = DateTime.now();
    final last = _lastPlayed[effect];
    final throttle = effect.contains('fire') ? _fireThrottle : _sfxThrottle;
    if (last != null && now.difference(last) < throttle) {
      return;
    }
    _lastPlayed[effect] = now;

    try {
      // Reuse pooled player (round-robin)
      final player = _pool[_nextPlayer % _poolSize];
      _nextPlayer++;
      player.stop();
      // Fire sound at 40% of normal SFX volume
      final vol = effect.contains('fire') ? _sfxVolume * 0.4 : _sfxVolume;
      player.setVolume(vol);
      player.setSource(AssetSource(effect));
      player.resume();
    } catch (e) {
      // Graceful fallback
    }
  }

  @override
  void dispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
    for (final player in _pool) {
      player.dispose();
    }
    _pool.clear();
  }
}
