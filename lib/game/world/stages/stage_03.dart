import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage03 = StageDefinition(
  id: StageId.stage3,
  bossSpawnTime: 65.0,
  bgTint: Color(0xFF08102A),
  starSpeed: 1.3,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 400,
    baseCooldown: 0.55,
    phase2HpRatio: 0.6,
    phase3HpRatio: 0.25,
    speed: 90,
    width: 88,
    height: 76,
  ),
  waves: [
    WaveTemplate(time: 2.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 4.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 8.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 11.0,
      count: 6,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 14.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 16.0,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 19.0, count: 7, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 22.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 24.0,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 27.0,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 30.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 32.0,
      count: 6,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 35.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 38.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 40.0, count: 7, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 43.0,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 46.0,
      count: 6,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 49.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 52.0,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 55.0, count: 4, enemyType: EnemyType.interceptor),
    WaveTemplate(
      time: 58.0,
      count: 6,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 60.0, count: 4, enemyType: EnemyType.gunship),
  ],
);
