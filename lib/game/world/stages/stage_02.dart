import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage02 = StageDefinition(
  id: StageId.stage2,
  bossSpawnTime: 45.0,
  bgTint: Color(0xFF060B1E),
  starSpeed: 1.1,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 120,
    baseCooldown: 0.7,
    phase2HpRatio: 0.5,
    phase3HpRatio: 0.2,
    speed: 70,
    width: 64,
    height: 56,
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
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 15.0, count: 1, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 19.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 24.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 28.0, count: 2, enemyType: EnemyType.interceptor),
    WaveTemplate(
      time: 33.0,
      count: 3,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 37.0, count: 2, enemyType: EnemyType.interceptor),
    WaveTemplate(time: 40.0, count: 3, enemyType: EnemyType.drone),
  ],
);
