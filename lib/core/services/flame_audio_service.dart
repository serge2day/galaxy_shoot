import 'package:flame_audio/flame_audio.dart';

import 'audio_service.dart';

/// Audio service using dedicated pre-created AudioPlayers per sound.
/// Same approach as Blockfall/Tetris - no FlameAudio.play() leak.
class FlameAudioService implements AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;
  double _musicVolume = 0.3;
  double _sfxVolume = 0.5;
  bool _paused = false;
  String _currentBgm = '';

  // Dedicated players per sound - created once, reused forever
  final Map<String, AudioPlayer> _players = {};

  // Throttle per sound
  final Map<String, int> _lastPlayedMs = {};

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  @override
  Future<void> initialize() async {
    try {
      // Create one dedicated player per SFX
      final sounds = [
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
        final player = AudioPlayer();
        await player.setSource(AssetSource(sound));
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.setVolume(_sfxVolume);
        _players[sound] = player;
      }

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
    for (final player in _players.values) {
      player.setVolume(_sfxVolume);
    }
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

    // Skip fire sound (too frequent even with throttle)
    if (effect.contains('fire') || effect.contains('enemy_hit')) return;

    // Throttle: 200ms for combat sounds, 500ms for rare sounds
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final lastMs = _lastPlayedMs[effect] ?? 0;
    final interval = effect.contains('death') ||
            effect.contains('damage') ||
            effect.contains('pickup')
        ? 200
        : 500;
    if (nowMs - lastMs < interval) return;
    _lastPlayedMs[effect] = nowMs;

    final player = _players[effect];
    if (player == null) return;

    try {
      player.seek(Duration.zero);
      player.resume();
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
      for (final player in _players.values) {
        player.dispose();
      }
      _players.clear();
    } catch (e) {
      // ignore
    }
  }
}
