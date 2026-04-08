import 'package:flame_audio/flame_audio.dart';

import 'audio_service.dart';

class FlameAudioService implements AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    try {
      // Pre-cache SFX
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
      // Audio files missing - graceful fallback
      _initialized = false;
    }
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBgm();
    }
  }

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  @override
  void playBgm(String track) {
    if (!_musicEnabled || !_initialized) return;
    try {
      FlameAudio.bgm.play(track);
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
    if (!_sfxEnabled || !_initialized) return;
    try {
      FlameAudio.play(effect);
    } catch (e) {
      // Graceful fallback
    }
  }

  @override
  void dispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
  }
}
