import 'dart:math';

import 'stages/stage_definition.dart';

class SpawnEvent {
  final double time;
  final int count;
  final EnemyMovementType movement;
  final double xStart;
  final double xSpacing;

  const SpawnEvent({
    required this.time,
    this.count = 4,
    this.movement = EnemyMovementType.straight,
    this.xStart = 60,
    this.xSpacing = 70,
  });
}

/// Legacy spawn timeline for backward compatibility.
/// Phase 3 stages use StageDefinition wave templates directly.
class SpawnTimeline {
  static List<SpawnEvent> buildLevel1({int seed = 0}) {
    final rng = Random(seed);
    final events = <SpawnEvent>[];

    const templates = [
      (time: 2.0, count: 3, movement: EnemyMovementType.straight),
      (time: 7.0, count: 4, movement: EnemyMovementType.sineWave),
      (time: 12.0, count: 3, movement: EnemyMovementType.diagonal),
      (time: 17.0, count: 5, movement: EnemyMovementType.straight),
      (time: 22.0, count: 4, movement: EnemyMovementType.sineWave),
      (time: 27.0, count: 3, movement: EnemyMovementType.diagonal),
      (time: 32.0, count: 5, movement: EnemyMovementType.straight),
      (time: 37.0, count: 4, movement: EnemyMovementType.sineWave),
      (time: 42.0, count: 4, movement: EnemyMovementType.diagonal),
      (time: 47.0, count: 5, movement: EnemyMovementType.sineWave),
      (time: 10.0, count: 2, movement: EnemyMovementType.diagonal),
      (time: 20.0, count: 3, movement: EnemyMovementType.straight),
      (time: 35.0, count: 3, movement: EnemyMovementType.sineWave),
      (time: 44.0, count: 4, movement: EnemyMovementType.straight),
    ];

    for (final t in templates) {
      final xStart = 40.0 + rng.nextDouble() * 50.0;
      final xSpacing = 55.0 + rng.nextDouble() * 30.0;
      events.add(
        SpawnEvent(
          time: t.time,
          count: t.count,
          movement: t.movement,
          xStart: xStart,
          xSpacing: xSpacing,
        ),
      );
    }

    events.sort((a, b) => a.time.compareTo(b.time));
    return events;
  }

  static double get bossSpawnTime => 55.0;
}
