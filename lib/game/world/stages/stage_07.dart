import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage07 = StageDefinition(
  id: StageId.stage7,
  bossSpawnTime: 60.0,
  bgTint: Color(0xFF180808),
  starSpeed: 1.5,
  hasBoss: false,
  bossConfig: BossConfig(baseHp: 1, baseCooldown: 1.0),
  waves: [
    WaveTemplate(time: 2.0, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 4.0, count: 3, enemyType: EnemyType.gunship),
    WaveTemplate(time: 6.5, count: 10, enemyType: EnemyType.swarmer, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 8.5, count: 7, enemyType: EnemyType.drone, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 11.0, count: 2, enemyType: EnemyType.carrier),
    WaveTemplate(time: 13.0, count: 8, enemyType: EnemyType.interceptor, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 15.5, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 17.5, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 20.0, count: 3, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop, isElite: true),
    WaveTemplate(time: 22.0, count: 9, enemyType: EnemyType.drone),
    WaveTemplate(time: 24.5, count: 3, enemyType: EnemyType.carrier, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 27.0, count: 16, enemyType: EnemyType.swarmer),
    WaveTemplate(time: 29.0, count: 6, enemyType: EnemyType.gunship, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 31.5, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 34.0, count: 10, enemyType: EnemyType.drone, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 36.0, count: 2, enemyType: EnemyType.gunship, isElite: true),
    WaveTemplate(time: 38.5, count: 12, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 41.0, count: 2, enemyType: EnemyType.carrier),
    WaveTemplate(time: 43.0, count: 8, enemyType: EnemyType.interceptor, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 45.5, count: 5, enemyType: EnemyType.gunship),
    WaveTemplate(time: 48.0, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 50.5, count: 7, enemyType: EnemyType.drone, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 53.0, count: 4, enemyType: EnemyType.gunship, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 55.5, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
  ],
);
