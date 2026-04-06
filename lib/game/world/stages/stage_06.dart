import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage06 = StageDefinition(
  id: StageId.stage6,
  bossSpawnTime: 75.0,
  bgTint: Color(0xFF14062E),
  starSpeed: 1.5,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 600,
    baseCooldown: 0.45,
    phase2HpRatio: 0.6,
    phase3HpRatio: 0.25,
    speed: 110,
    width: 96,
    height: 82,
  ),
  waves: [
    WaveTemplate(
      time: 2.0,
      count: 8,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 4.0,
      count: 7,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 7.0,
      count: 18,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 9.5,
      count: 5,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 12.0,
      count: 9,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 14.0,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 16.5,
      count: 7,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 19.0,
      count: 18,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 21.0,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 23.5,
      count: 8,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 26.0,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 28.0,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 30.5,
      count: 20,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 33.0,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 35.0,
      count: 8,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 37.5,
      count: 7,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 39.5,
      count: 18,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 42.0,
      count: 5,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 44.0,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 46.5,
      count: 8,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 49.0,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 51.0,
      count: 18,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 53.5,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 56.0,
      count: 9,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 58.5,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 61.0,
      count: 20,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 63.5,
      count: 7,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 66.0,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 69.0,
      count: 7,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 72.0,
      count: 5,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
    ),
  ],
);
