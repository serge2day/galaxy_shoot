import 'dart:math';

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
  static const List<_WaveTemplate> _templates = [
    _WaveTemplate(time: 2.0, count: 3, movement: EnemyMovement.straight),
    _WaveTemplate(time: 7.0, count: 4, movement: EnemyMovement.sineWave),
    _WaveTemplate(time: 12.0, count: 3, movement: EnemyMovement.diagonal),
    _WaveTemplate(time: 17.0, count: 5, movement: EnemyMovement.straight),
    _WaveTemplate(time: 22.0, count: 4, movement: EnemyMovement.sineWave),
    _WaveTemplate(time: 27.0, count: 3, movement: EnemyMovement.diagonal),
    _WaveTemplate(time: 32.0, count: 5, movement: EnemyMovement.straight),
    _WaveTemplate(time: 37.0, count: 4, movement: EnemyMovement.sineWave),
    _WaveTemplate(time: 42.0, count: 4, movement: EnemyMovement.diagonal),
    _WaveTemplate(time: 47.0, count: 5, movement: EnemyMovement.sineWave),
    // Phase 2 extra waves for variety
    _WaveTemplate(time: 10.0, count: 2, movement: EnemyMovement.diagonal),
    _WaveTemplate(time: 20.0, count: 3, movement: EnemyMovement.straight),
    _WaveTemplate(time: 35.0, count: 3, movement: EnemyMovement.sineWave),
    _WaveTemplate(time: 44.0, count: 4, movement: EnemyMovement.straight),
  ];

  static List<SpawnEvent> buildLevel1({int seed = 0}) {
    final rng = Random(seed);
    final events = <SpawnEvent>[];

    for (final template in _templates) {
      // Add slight seeded variation to xStart/xSpacing
      final xStart = 40.0 + rng.nextDouble() * 50.0;
      final xSpacing = 55.0 + rng.nextDouble() * 30.0;
      events.add(
        SpawnEvent(
          time: template.time,
          count: template.count,
          movement: template.movement,
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

class _WaveTemplate {
  final double time;
  final int count;
  final EnemyMovement movement;

  const _WaveTemplate({
    required this.time,
    required this.count,
    required this.movement,
  });
}
