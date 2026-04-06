import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage04 = StageDefinition(
  id: StageId.stage4,
  bossSpawnTime: 45.0,
  bgTint: Color(0xFF0D0520),
  starSpeed: 1.2,
  hasBoss: false,
  bossConfig: BossConfig(baseHp: 1, baseCooldown: 1.0),
  waves: [
    WaveTemplate(time: 2.0, count: 4, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 6.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 10.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 14.0,
      count: 5,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 18.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 22.0, count: 4, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 26.0,
      count: 6,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 30.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 34.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 38.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 42.0,
      count: 4,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
  ],
);
