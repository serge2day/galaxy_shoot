import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage09 = StageDefinition(
  id: StageId.stage9,
  bossSpawnTime: 70.0,
  bgTint: Color(0xFF200808),
  starSpeed: 1.8,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 500,
    baseCooldown: 0.35,
    phase2HpRatio: 0.65,
    phase3HpRatio: 0.3,
    speed: 110,
    width: 110,
    height: 95,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
      isElite: true,
    ),
    WaveTemplate(
      time: 5.0,
      count: 3,
      enemyType: EnemyType.gunship,
      isElite: true,
    ),
    WaveTemplate(
      time: 9.0,
      count: 8,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 13.0, count: 2, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 17.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
      isElite: true,
    ),
    WaveTemplate(
      time: 21.0,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
      isElite: true,
    ),
    WaveTemplate(
      time: 25.0,
      count: 7,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 29.0, count: 3, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 33.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
      isElite: true,
    ),
    WaveTemplate(
      time: 37.0,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 41.0, count: 6, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 45.0,
      count: 2,
      enemyType: EnemyType.carrier,
      isElite: true,
    ),
    WaveTemplate(
      time: 49.0,
      count: 8,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 53.0,
      count: 3,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 57.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
      isElite: true,
    ),
    WaveTemplate(time: 61.0, count: 3, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 65.0,
      count: 3,
      enemyType: EnemyType.gunship,
      isElite: true,
    ),
  ],
);
