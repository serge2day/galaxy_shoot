import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage05 = StageDefinition(
  id: StageId.stage5,
  bossSpawnTime: 50.0,
  bgTint: Color(0xFF100828),
  starSpeed: 1.4,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 160,
    baseCooldown: 0.6,
    phase2HpRatio: 0.5,
    phase3HpRatio: 0.2,
    speed: 85,
    width: 72,
    height: 62,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 6.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 10.0,
      count: 6,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 14.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 18.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 22.0,
      count: 5,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 26.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 30.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 34.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 38.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 42.0,
      count: 6,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 46.0, count: 4, enemyType: EnemyType.drone),
  ],
);
