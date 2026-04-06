import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage05 = StageDefinition(
  id: StageId.stage5,
  bossSpawnTime: 60.0,
  bgTint: Color(0xFF100828),
  starSpeed: 1.35,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 100,
    baseCooldown: 0.5,
    phase2HpRatio: 0.55,
    phase3HpRatio: 0.2,
    speed: 95,
    width: 78,
    height: 66,
  ),
  waves: [
    WaveTemplate(time: 2.0, count: 7, enemyType: EnemyType.drone, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 4.0, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 7.0, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 9.0, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 11.5, count: 8, enemyType: EnemyType.drone, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 14.0, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 16.0, count: 16, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 18.5, count: 4, enemyType: EnemyType.gunship, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 21.0, count: 9, enemyType: EnemyType.drone, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 23.0, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 25.5, count: 3, enemyType: EnemyType.carrier, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 28.0, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 30.0, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 32.5, count: 8, enemyType: EnemyType.interceptor, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 35.0, count: 9, enemyType: EnemyType.drone, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 37.0, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 39.5, count: 15, enemyType: EnemyType.swarmer, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 42.0, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.flanking),
    WaveTemplate(time: 44.0, count: 3, enemyType: EnemyType.carrier, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 47.0, count: 8, enemyType: EnemyType.drone, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 49.0, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.zigzag),
    WaveTemplate(time: 52.0, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 55.0, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.flanking),
  ],
);
