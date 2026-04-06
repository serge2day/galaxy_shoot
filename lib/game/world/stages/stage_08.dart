import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage08 = StageDefinition(
  id: StageId.stage8,
  bossSpawnTime: 55.0,
  bgTint: Color(0xFF1A0A0A),
  starSpeed: 1.6,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 65,
    baseCooldown: 0.5,
    phase2HpRatio: 0.5,
    phase3HpRatio: 0.2,
    speed: 95,
    width: 80,
    height: 68,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
      isElite: true,
    ),
    WaveTemplate(time: 5.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 9.0,
      count: 7,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(time: 13.0, count: 2, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 17.0,
      count: 3,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
      isElite: true,
    ),
    WaveTemplate(
      time: 21.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 25.0,
      count: 6,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(time: 29.0, count: 2, enemyType: EnemyType.carrier),
    WaveTemplate(
      time: 33.0,
      count: 3,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 37.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
      isElite: true,
    ),
    WaveTemplate(time: 41.0, count: 5, enemyType: EnemyType.drone),
    WaveTemplate(time: 45.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(
      time: 49.0,
      count: 2,
      enemyType: EnemyType.carrier,
      isElite: true,
    ),
  ],
);
