import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage01 = StageDefinition(
  id: StageId.stage1,
  bossSpawnTime: 55.0,
  bgTint: Color(0xFF050A18),
  starSpeed: 1.0,
  hasBoss: false,
  bossConfig: BossConfig(baseHp: 1, baseCooldown: 1.0),
  waves: [
    WaveTemplate(time: 2.0, count: 3, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 7.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 12.0,
      count: 3,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 16.0,
      count: 2,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 20.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 25.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 30.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 35.0, count: 2, enemyType: EnemyType.interceptor),
    WaveTemplate(
      time: 40.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 45.0, count: 3, enemyType: EnemyType.drone),
    WaveTemplate(
      time: 48.0,
      count: 2,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
  ],
);
