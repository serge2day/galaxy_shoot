import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage08 = StageDefinition(
  id: StageId.stage8,
  bossSpawnTime: 70.0,
  bgTint: Color(0xFF1A0A0A),
  starSpeed: 1.6,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 220,
    baseCooldown: 0.45,
    phase2HpRatio: 0.55,
    phase3HpRatio: 0.2,
    speed: 110,
    width: 84,
    height: 72,
  ),
  waves: [
    WaveTemplate(time: 2.0, count: 8, enemyType: EnemyType.drone, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 4.0, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 6.5, count: 4, enemyType: EnemyType.gunship),
    WaveTemplate(time: 9.0, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 11.0, count: 3, enemyType: EnemyType.carrier),
    WaveTemplate(time: 13.5, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 15.5, count: 3, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop, isElite: true),
    WaveTemplate(time: 18.0, count: 10, enemyType: EnemyType.drone),
    WaveTemplate(time: 20.0, count: 16, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 22.5, count: 5, enemyType: EnemyType.gunship, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 25.0, count: 2, enemyType: EnemyType.carrier, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 27.0, count: 8, enemyType: EnemyType.interceptor, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 29.5, count: 9, enemyType: EnemyType.drone, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 31.5, count: 2, enemyType: EnemyType.gunship, isElite: true),
    WaveTemplate(time: 34.0, count: 12, enemyType: EnemyType.swarmer),
    WaveTemplate(time: 36.0, count: 6, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 38.5, count: 3, enemyType: EnemyType.carrier),
    WaveTemplate(time: 41.0, count: 18, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 43.0, count: 5, enemyType: EnemyType.gunship),
    WaveTemplate(time: 45.5, count: 10, enemyType: EnemyType.drone, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 48.0, count: 7, enemyType: EnemyType.interceptor, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 50.0, count: 2, enemyType: EnemyType.carrier, isElite: true),
    WaveTemplate(time: 52.5, count: 14, enemyType: EnemyType.swarmer, movement: EnemyMovementType.diagonal),
    WaveTemplate(time: 55.0, count: 6, enemyType: EnemyType.gunship, movement: EnemyMovementType.sineWave),
    WaveTemplate(time: 57.5, count: 8, enemyType: EnemyType.interceptor, movement: EnemyMovementType.swoop),
    WaveTemplate(time: 60.0, count: 10, enemyType: EnemyType.drone),
    WaveTemplate(time: 62.5, count: 4, enemyType: EnemyType.gunship),
    WaveTemplate(time: 65.0, count: 16, enemyType: EnemyType.swarmer, movement: EnemyMovementType.swoop),
  ],
);
