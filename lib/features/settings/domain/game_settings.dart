import 'fire_mode.dart';

class GameSettings {
  final FireMode fireMode;
  final bool musicEnabled;
  final bool sfxEnabled;
  final bool hapticsEnabled;

  const GameSettings({
    this.fireMode = FireMode.auto,
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.hapticsEnabled = true,
  });

  GameSettings copyWith({
    FireMode? fireMode,
    bool? musicEnabled,
    bool? sfxEnabled,
    bool? hapticsEnabled,
  }) {
    return GameSettings(
      fireMode: fireMode ?? this.fireMode,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
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
          hapticsEnabled == other.hapticsEnabled;

  @override
  int get hashCode =>
      Object.hash(fireMode, musicEnabled, sfxEnabled, hapticsEnabled);
}
