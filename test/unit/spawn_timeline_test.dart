import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/game/world/spawn_timeline.dart';

void main() {
  test('level 1 timeline has waves', () {
    final waves = SpawnTimeline.buildLevel1();
    expect(waves, isNotEmpty);
  });

  test('waves are in chronological order', () {
    final waves = SpawnTimeline.buildLevel1();
    for (int i = 1; i < waves.length; i++) {
      expect(waves[i].time, greaterThanOrEqualTo(waves[i - 1].time));
    }
  });

  test('all waves happen before boss spawn', () {
    final waves = SpawnTimeline.buildLevel1();
    for (final wave in waves) {
      expect(wave.time, lessThan(SpawnTimeline.bossSpawnTime));
    }
  });

  test('boss spawn time is positive', () {
    expect(SpawnTimeline.bossSpawnTime, greaterThan(0));
  });

  test('each wave spawns at least 1 enemy', () {
    final waves = SpawnTimeline.buildLevel1();
    for (final wave in waves) {
      expect(wave.count, greaterThan(0));
    }
  });
}
