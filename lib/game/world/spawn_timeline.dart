import '../components/enemies/enemy_ship.dart';

class SpawnEvent {
  final double time;
  final int count;
  final EnemyMovement movement;
  final double xStart;
  final double xSpacing;

  const SpawnEvent({
    required this.time,
    this.count = 4,
    this.movement = EnemyMovement.straight,
    this.xStart = 60,
    this.xSpacing = 70,
  });
}

class SpawnTimeline {
  static List<SpawnEvent> buildLevel1() {
    return const [
      // Wave 1 - straight
      SpawnEvent(
        time: 2.0,
        count: 3,
        movement: EnemyMovement.straight,
        xStart: 80,
        xSpacing: 80,
      ),
      // Wave 2 - sine wave
      SpawnEvent(
        time: 7.0,
        count: 4,
        movement: EnemyMovement.sineWave,
        xStart: 60,
        xSpacing: 70,
      ),
      // Wave 3 - diagonal
      SpawnEvent(
        time: 12.0,
        count: 3,
        movement: EnemyMovement.diagonal,
        xStart: 40,
        xSpacing: 90,
      ),
      // Wave 4 - straight heavy
      SpawnEvent(
        time: 17.0,
        count: 5,
        movement: EnemyMovement.straight,
        xStart: 50,
        xSpacing: 60,
      ),
      // Wave 5 - sine
      SpawnEvent(
        time: 22.0,
        count: 4,
        movement: EnemyMovement.sineWave,
        xStart: 70,
        xSpacing: 65,
      ),
      // Wave 6 - mixed
      SpawnEvent(
        time: 27.0,
        count: 3,
        movement: EnemyMovement.diagonal,
        xStart: 60,
        xSpacing: 80,
      ),
      // Wave 7 - heavy
      SpawnEvent(
        time: 32.0,
        count: 5,
        movement: EnemyMovement.straight,
        xStart: 40,
        xSpacing: 65,
      ),
      // Wave 8 - sine weave
      SpawnEvent(
        time: 37.0,
        count: 4,
        movement: EnemyMovement.sineWave,
        xStart: 50,
        xSpacing: 75,
      ),
      // Wave 9 - diagonal rush
      SpawnEvent(
        time: 42.0,
        count: 4,
        movement: EnemyMovement.diagonal,
        xStart: 30,
        xSpacing: 80,
      ),
      // Wave 10 - final wave before boss
      SpawnEvent(
        time: 47.0,
        count: 5,
        movement: EnemyMovement.sineWave,
        xStart: 50,
        xSpacing: 60,
      ),
    ];
  }

  static double get bossSpawnTime => 55.0;
}
