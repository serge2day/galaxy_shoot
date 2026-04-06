import 'dart:ui';

import '../../../features/campaign/domain/stage_id.dart';
import '../../components/enemies/enemy_type.dart';

class WaveTemplate {
  final double time;
  final int count;
  final EnemyType enemyType;
  final EnemyMovementType movement;
  final bool isElite;

  const WaveTemplate({
    required this.time,
    required this.count,
    this.enemyType = EnemyType.drone,
    this.movement = EnemyMovementType.straight,
    this.isElite = false,
  });
}

enum EnemyMovementType { straight, sineWave, diagonal, swoop, zigzag, flanking }

class BossConfig {
  final int baseHp;
  final double baseCooldown;
  final double phase2HpRatio;
  final double phase3HpRatio;
  final double speed;
  final double width;
  final double height;

  const BossConfig({
    required this.baseHp,
    required this.baseCooldown,
    this.phase2HpRatio = 0.6,
    this.phase3HpRatio = 0.25,
    this.speed = 80,
    this.width = 80,
    this.height = 70,
  });
}

class StageDefinition {
  final StageId id;
  final List<WaveTemplate> waves;
  final double bossSpawnTime;
  final BossConfig bossConfig;
  final Color bgTint;
  final double starSpeed;
  final bool hasBoss;

  const StageDefinition({
    required this.id,
    required this.waves,
    required this.bossSpawnTime,
    required this.bossConfig,
    this.bgTint = const Color(0xFF050A18),
    this.starSpeed = 1.0,
    this.hasBoss = true,
  });
}
