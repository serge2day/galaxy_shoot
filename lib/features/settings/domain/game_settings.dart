import 'fire_mode.dart';

class GameSettings {
  final FireMode fireMode;

  const GameSettings({this.fireMode = FireMode.auto});

  GameSettings copyWith({FireMode? fireMode}) {
    return GameSettings(fireMode: fireMode ?? this.fireMode);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSettings &&
          runtimeType == other.runtimeType &&
          fireMode == other.fireMode;

  @override
  int get hashCode => fireMode.hashCode;
}
