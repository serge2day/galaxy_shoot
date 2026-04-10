import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage04 = StageDefinition(
  id: StageId.stage4,
  bossSpawnTime: 55.0,
  bgTint: Color(0xFF0D0520),
  starSpeed: 1.2,
  hasBoss: false,
  bossConfig: BossConfig(baseHp: 1, baseCooldown: 1.0),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 7,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 4.5,
      count: 5,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 7.0,
      count: 6,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 9.0,
      count: 12,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 12.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 14.0,
      count: 7,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 16.5,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 19.0,
      count: 14,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 21.0,
      count: 5,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 23.5,
      count: 6,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 26.0,
      count: 9,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 28.0,
      count: 12,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 30.0,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 32.5,
      count: 7,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 35.0,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 37.0,
      count: 13,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 39.5,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 42.0,
      count: 6,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 44.0,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 47.0,
      count: 5,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 50.0,
      count: 12,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.zigzag,
    ),
  ],
);
