import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';
import 'stage_definition.dart';

const stage09 = StageDefinition(
  id: StageId.stage9,
  bossSpawnTime: 85.0,
  bgTint: Color(0xFF200808),
  starSpeed: 1.8,
  hasBoss: true,
  bossConfig: BossConfig(
    baseHp: 280,
    baseCooldown: 0.4,
    phase2HpRatio: 0.65,
    phase3HpRatio: 0.3,
    speed: 130,
    width: 110,
    height: 95,
  ),
  waves: [
    // Immediate pressure
    WaveTemplate(
      time: 2.0,
      count: 10,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 4.0,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 6.0,
      count: 20,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.diagonal,
    ),
    WaveTemplate(
      time: 8.5,
      count: 4,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 10.5,
      count: 9,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    // Elites start
    WaveTemplate(
      time: 13.0,
      count: 4,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
      isElite: true,
    ),
    WaveTemplate(
      time: 15.0,
      count: 22,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 17.0,
      count: 7,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 19.5,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 21.5,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    // Heavy mid-section
    WaveTemplate(
      time: 24.0,
      count: 25,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 26.0,
      count: 3,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
      isElite: true,
    ),
    WaveTemplate(
      time: 28.0,
      count: 9,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 30.5,
      count: 4,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 33.0,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 35.0,
      count: 20,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 37.5,
      count: 7,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    // Relentless assault
    WaveTemplate(
      time: 40.0,
      count: 11,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 42.0,
      count: 3,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.zigzag,
      isElite: true,
    ),
    WaveTemplate(
      time: 44.5,
      count: 24,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 46.5,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 49.0,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 51.0,
      count: 8,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
    // Final gauntlet
    WaveTemplate(
      time: 53.5,
      count: 22,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.swoop,
    ),
    WaveTemplate(
      time: 55.5,
      count: 4,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.flanking,
      isElite: true,
    ),
    WaveTemplate(
      time: 58.0,
      count: 4,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 60.0,
      count: 11,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 62.5,
      count: 10,
      enemyType: EnemyType.drone,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 65.0,
      count: 25,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 67.5,
      count: 7,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.sineWave,
    ),
    WaveTemplate(
      time: 70.0,
      count: 4,
      enemyType: EnemyType.carrier,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 72.5,
      count: 9,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 75.0,
      count: 20,
      enemyType: EnemyType.swarmer,
      movement: EnemyMovementType.flanking,
    ),
    WaveTemplate(
      time: 78.0,
      count: 6,
      enemyType: EnemyType.gunship,
      movement: EnemyMovementType.zigzag,
    ),
    WaveTemplate(
      time: 80.0,
      count: 8,
      enemyType: EnemyType.interceptor,
      movement: EnemyMovementType.flanking,
    ),
  ],
);
