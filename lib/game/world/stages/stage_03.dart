import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage03 = StageDefinition(
  id: StageId.stage3,
  bossSpawnTime: 55.0,
  bgTint: Color(0xFF08102A),
  starSpeed: 1.3,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 200,
    baseCooldown: 0.55,
    phase2HpRatio: 0.6,
    phase3HpRatio: 0.25,
    speed: 90,
    width: 88,
    height: 76,
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
      time: 10.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 14.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 18.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 22.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 26.0,
      count: 2,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 30.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 34.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(time: 38.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 42.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 46.0, count: 4, enemyType: EnemyType.drone),
    WaveTemplate(time: 50.0, count: 2, enemyType: EnemyType.gunship),
  ],
);
