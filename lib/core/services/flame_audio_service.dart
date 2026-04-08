import 'package:flame_audio/flame_audio.dart';

import 'audio_service.dart';

/// Simple audio service. Uses FlameAudio directly with heavy throttling.
/// Player fire SFX is disabled to prevent performance issues.
class FlameAudioService implements AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;
  double _musicVolume = 0.3;
  double _sfxVolume = 0.5;
  bool _paused = false;

  // Throttle to prevent SFX spam
  final Map<String, int> _lastPlayedMs = {};
  static const int _minIntervalMs = 300;

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  @override
  Future<void> initialize() async {
    try {
      await FlameAudio.audioCache.loadAll([
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
      // ignore
    }
  }

  @override
  void stopBgm() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      // ignore
    }
  }

  @override
  void playSfx(String effect) {
    if (!_sfxEnabled || !_initialized || _paused) return;

    // Skip fire and hit sounds entirely - they spam too much
    if (effect.contains('fire') || effect.contains('enemy_hit')) return;

    // Throttle: minimum 300ms between same sound
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final lastMs = _lastPlayedMs[effect] ?? 0;
    if (nowMs - lastMs < _minIntervalMs) return;
    _lastPlayedMs[effect] = nowMs;

    try {
      FlameAudio.play(effect, volume: _sfxVolume);
    } catch (e) {
      // ignore
    }
  }

  @override
  void dispose() {
    try {
      FlameAudio.bgm.stop();
      FlameAudio.bgm.dispose();
    } catch (e) {
      // ignore
    }
  }
}
