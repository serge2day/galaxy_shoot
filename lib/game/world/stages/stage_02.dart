import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage02 = StageDefinition(
  id: StageId.stage2,
  bossSpawnTime: 65.0,
  bgTint: Color(0xFF0A0520),
  starSpeed: 1.3,
  bossConfig: BossConfig(
    baseHp: 60,
    baseCooldown: 0.5,
    phase2HpRatio: 0.6,
    phase3HpRatio: 0.25,
    speed: 100,
    width: 90,
    height: 75,
  ),
  waves: [
    WaveTemplate(time: 2.0, count: 4, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 6.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 11.0,
      count: 3,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 15.0, count: 1, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 19.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 24.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 28.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 33.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 38.0, count: 4, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 42.0,
      count: 2,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 47.0, count: 4, enemyType: EnemyType.interceptor),
    WaveTemplate(
      time: 52.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 56.0, count: 2, enemyType: EnemyType.gunship),
  ],
);
