import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage03 = StageDefinition(
  id: StageId.stage3,
  bossSpawnTime: 75.0,
  bgTint: Color(0xFF120008),
  starSpeed: 1.6,
  bossConfig: BossConfig(
    baseHp: 80,
    baseCooldown: 0.45,
    phase2HpRatio: 0.65,
    phase3HpRatio: 0.3,
    speed: 120,
    width: 100,
    height: 85,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 6.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 11.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 15.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 20.0,
      count: 2,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 24.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 29.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(time: 33.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 38.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 43.0,
      count: 2,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 48.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 53.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 58.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(time: 63.0, count: 4, enemyType: EnemyType.interceptor),
    WaveTemplate(
      time: 68.0,
      count: 2,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
  ],
);
