import 'package:flame_audio/flame_audio.dart';

import 'audio_service.dart';

/// Minimal audio service. Only plays BGM and rare one-shot SFX.
/// Avoids FlameAudio.play() spam which leaks AudioPlayers.
class FlameAudioService implements AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;
  double _musicVolume = 0.3;
  double _sfxVolume = 0.5;
  bool _paused = false;
  String _currentBgm = '';

  // Single reusable player for one-shot SFX
  AudioPlayer? _sfxPlayer;
  int _lastSfxMs = 0;

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  @override
  Future<void> initialize() async {
    try {
      // Only pre-load the rare important sounds
      await FlameAudio.audioCache.loadAll([
        'victory.mp3',
        'game_over.mp3',
        'boss_enter.mp3',
        'boss_death.mp3',
        'evolution_up.mp3',
      ]);
      _sfxPlayer = AudioPlayer();
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
    if (!_musicEnabled || !_initialized) return;
    // Don't restart the same track
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
    if (!_sfxEnabled || !_initialized || _paused) return;

    // Only play rare important sounds - skip frequent combat SFX
    if (effect.contains('fire') ||
        effect.contains('enemy_hit') ||
        effect.contains('enemy_death') ||
        effect.contains('player_damage') ||
        effect.contains('player_death') ||
        effect.contains('pickup_collect') ||
        effect.contains('boss_phase')) {
      return;
    }

    // Minimum 1 second between any SFX
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - _lastSfxMs < 1000) return;
    _lastSfxMs = nowMs;

    try {
      _sfxPlayer?.stop();
      _sfxPlayer?.setVolume(_sfxVolume);
      _sfxPlayer?.setSource(AssetSource(effect));
      _sfxPlayer?.resume();
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
      _sfxPlayer?.dispose();
    } catch (e) {
      // ignore
    }
  }
}
