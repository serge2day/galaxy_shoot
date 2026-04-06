import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage06 = StageDefinition(
  id: StageId.stage6,
  bossSpawnTime: 60.0,
  bgTint: Color(0xFF140A30),
  starSpeed: 1.5,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 300,
    baseCooldown: 0.45,
    phase2HpRatio: 0.6,
    phase3HpRatio: 0.25,
    speed: 100,
    width: 96,
    height: 82,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 5.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 9.0,
      count: 6,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 13.0, count: 1, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 17.0,
      count: 4,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 21.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 25.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 29.0,
      count: 7,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 33.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 37.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(time: 41.0, count: 1, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 45.0,
      count: 5,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 49.0,
      count: 3,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(time: 53.0, count: 2, enemyType: EnemyType.gunship),
    WaveTemplate(time: 56.0, count: 5, enemyType: EnemyType.swarmer),
  ],
);
