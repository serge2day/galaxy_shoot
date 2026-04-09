import 'fire_mode.dart';

class GameSettings {
  final FireMode fireMode;
  final bool musicEnabled;
  final bool sfxEnabled;
  final bool hapticsEnabled;
  final double musicVolume;
  final double sfxVolume;

  const GameSettings({
    this.fireMode = FireMode.auto,
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.hapticsEnabled = true,
    this.musicVolume = 0.5,
    this.sfxVolume = 0.5,
  });

  GameSettings copyWith({
    FireMode? fireMode,
    bool? musicEnabled,
    bool? sfxEnabled,
    bool? hapticsEnabled,
    double? musicVolume,
    double? sfxVolume,
  }) {
    return GameSettings(
      fireMode: fireMode ?? this.fireMode,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      musicVolume: musicVolume ?? this.musicVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettings &&
          runtimeType == other.runtimeType &&
          fireMode == other.fireMode &&
          musicEnabled == other.musicEnabled &&
          sfxEnabled == other.sfxEnabled &&
          hapticsEnabled == other.hapticsEnabled &&
          musicVolume == other.musicVolume &&
          sfxVolume == other.sfxVolume;

  @override
  int get hashCode => Object.hash(
    fireMode,
    musicEnabled,
    sfxEnabled,
    hapticsEnabled,
    musicVolume,
    sfxVolume,
  );
}
