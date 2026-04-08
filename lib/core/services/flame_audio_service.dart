import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

import 'audio_service.dart';

/// Audio service using native SoundPool for SFX (via MethodChannel)
/// and FlameAudio.bgm for music. Same architecture as Blockfall/Tetris.
class FlameAudioService implements AudioService {
  static const _channel = MethodChannel('com.starvane/sfx');

  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _sfxLoaded = false;
  double _musicVolume = 0.5;
  double _sfxVolume = 0.3;
  String _currentBgm = '';

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  @override
  Future<void> initialize() async {
    if (_sfxLoaded) return;

    final sounds = [
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
    ];

    for (final sound in sounds) {
      try {
        await _channel.invokeMethod('loadSound', {'name': sound});
      } catch (e) {
        // MethodChannel not available - silent fallback
      }
    }

    // Wait for SoundPool to finish loading
    await Future.delayed(const Duration(milliseconds: 500));
    _sfxLoaded = true;

    try {
      await _channel.invokeMethod('setVolume', {'volume': _sfxVolume});
    } catch (e) {
      // ignore
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
    try {
      _channel.invokeMethod('setVolume', {'volume': _sfxVolume});
    } catch (e) {
      // ignore
    }
  }

  void pauseAll() {
    try {
      FlameAudio.bgm.pause();
    } catch (e) {
      // ignore
    }
  }

  void resumeAll() {
    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      // ignore
    }
  }

  @override
  void playBgm(String track) {
    if (!_musicEnabled) return;
    if (_currentBgm == track) return;
    try {
      FlameAudio.bgm.stop();
      _currentBgm = track;
      FlameAudio.bgm.play(track, volume: _musicVolume);
    } catch (e) {
      // ignore
    }
  }

  @override
  void stopBgm() {
    _currentBgm = '';
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      // ignore
    }
  }

  @override
  void playSfx(String effect) {
    if (!_sfxEnabled || !_sfxLoaded) return;
    // Fire-and-forget via native SoundPool - no await, no leak
    try {
      _channel.invokeMethod('playSound', {'name': effect});
    } catch (e) {
      // ignore
    }
  }

  @override
  void dispose() {
    _currentBgm = '';
    try {
      FlameAudio.bgm.stop();
      FlameAudio.bgm.dispose();
    } catch (e) {
      // ignore
    }
  }
}
