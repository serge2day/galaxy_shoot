import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../../world/stages/stage_definition.dart';
import '../effects/explosion_effect.dart';
import '../projectiles/player_bullet.dart';
import 'boss_weapon.dart';

enum BossPhase { entering, phase1, phase2, phase3 }

class BossShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  late int hp;
  late int maxHp;
  BossPhase phase = BossPhase.entering;

  final BossConfig config;
  final int stageIndex;

  late BossWeapon _weapon;
  double _elapsed = 0;
  final double _targetY = 80;

  BossShip({
    required Vector2 startPosition,
    required this.config,
    required this.stageIndex,
  }) : super(
         position: startPosition,
         size: Vector2(config.width, config.height),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    final mods = game.difficultyModifiers;
    maxHp = (config.baseHp * mods.bossHpMultiplier).ceil();
    hp = maxHp;

    final baseCooldown = config.baseCooldown * mods.bossFireRateMultiplier;
    _weapon = BossWeapon(
      cooldown: baseCooldown,
      firePattern: BossFirePattern.spread,
    );
    add(RectangleHitbox(size: size * 0.85, position: size * 0.075));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    switch (phase) {
      case BossPhase.entering:
        position.y += 60 * dt;
        if (position.y >= _targetY) {
          position.y = _targetY;
          phase = BossPhase.phase1;
          add(_weapon);
        }
        break;
      case BossPhase.phase1:
        _movePhase1(dt);
        _checkPhaseTransitions();
        break;
      case BossPhase.phase2:
        _movePhase2(dt);
        _checkPhaseTransitions();
        break;
      case BossPhase.phase3:
        _movePhase3(dt);
        break;
    }
  }

  void _movePhase1(double dt) {
    // Lateral movement
    final gameWidth = game.size.x;
    position.x = gameWidth / 2 + sin(_elapsed * 0.8) * (gameWidth * 0.3);
  }

  void _movePhase2(double dt) {
    // Faster lateral + vertical bobbing
    final gameWidth = game.size.x;
    position.x = gameWidth / 2 + sin(_elapsed * 1.5) * (gameWidth * 0.35);
    position.y = _targetY + sin(_elapsed * 2.0) * 20;
  }

  void _movePhase3(double dt) {
    // Erratic movement pattern
    final gameWidth = game.size.x;
    position.x =
        gameWidth / 2 +
        sin(_elapsed * 2.2) * (gameWidth * 0.3) +
        cos(_elapsed * 3.5) * (gameWidth * 0.1);
    position.y = _targetY + sin(_elapsed * 2.8) * 30 + cos(_elapsed * 1.7) * 15;
  }

  void _checkPhaseTransitions() {
    final hpRatio = hp / maxHp;
    if (phase == BossPhase.phase1 && hpRatio <= config.phase2HpRatio) {
      phase = BossPhase.phase2;
      final mods = game.difficultyModifiers;
      _weapon.cooldown =
          config.baseCooldown * 0.6 * mods.bossFireRateMultiplier;
      _weapon.firePattern = BossFirePattern.burst;
    } else if (phase == BossPhase.phase2 && hpRatio <= config.phase3HpRatio) {
      phase = BossPhase.phase3;
      final mods = game.difficultyModifiers;
      _weapon.cooldown =
          config.baseCooldown * 0.35 * mods.bossFireRateMultiplier;
      _weapon.firePattern = BossFirePattern.radial;
    }
  }

  // --- Visual colors based on stageIndex ---
  Color get _bodyColor {
    switch (stageIndex) {
      case 0:
        return phase == BossPhase.phase3
            ? const Color(0xFFD50000)
            : const Color(0xFF6A1B9A);
      case 1:
        return phase == BossPhase.phase3
            ? const Color(0xFF00695C)
            : const Color(0xFF004D40);
      case 2:
        return phase == BossPhase.phase3
            ? const Color(0xFFFF1744)
            : const Color(0xFFB71C1C);
      default:
        return const Color(0xFF6A1B9A);
    }
  }

  Color get _coreColor {
    switch (stageIndex) {
      case 0:
        return phase == BossPhase.phase3
            ? const Color(0xFFFF5252)
            : const Color(0xFF9C27B0);
      case 1:
        return phase == BossPhase.phase3
            ? const Color(0xFF26A69A)
            : const Color(0xFF00897B);
      case 2:
        return phase == BossPhase.phase3
            ? const Color(0xFFFF8A80)
            : const Color(0xFFD32F2F);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  Color get _glowColor {
    switch (stageIndex) {
      case 0:
        return phase.index >= BossPhase.phase2.index
            ? const Color(0x30FF1744)
            : const Color(0x207C4DFF);
      case 1:
        return phase.index >= BossPhase.phase2.index
            ? const Color(0x3000BFA5)
            : const Color(0x20004D40);
      case 2:
        return phase.index >= BossPhase.phase2.index
            ? const Color(0x30FF1744)
            : const Color(0x20B71C1C);
      default:
        return const Color(0x207C4DFF);
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = _glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, glowPaint);

    final bodyPath = Path()
      ..moveTo(w / 2, h * 0.1)
      ..lineTo(w, h * 0.4)
      ..lineTo(w * 0.9, h * 0.8)
      ..lineTo(w * 0.7, h)
      ..lineTo(w * 0.3, h)
      ..lineTo(w * 0.1, h * 0.8)
      ..lineTo(0, h * 0.4)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = _bodyColor);

    final corePath = Path()
      ..moveTo(w / 2, h * 0.2)
      ..lineTo(w * 0.75, h * 0.45)
      ..lineTo(w * 0.65, h * 0.8)
      ..lineTo(w * 0.35, h * 0.8)
      ..lineTo(w * 0.25, h * 0.45)
      ..close();
    canvas.drawPath(corePath, Paint()..color = _coreColor);

    final eyePaint = Paint()
      ..color = const Color(0xFFFFFF00)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(w / 2, h * 0.4), 5, eyePaint);

    // Phase 3 indicator: pulsing red outline
    if (phase == BossPhase.phase3) {
      final pulse = (sin(_elapsed * 6) + 1) / 2;
      final outlinePaint = Paint()
        ..color = Color.fromRGBO(255, 23, 68, 0.3 + pulse * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(w / 2, h / 2), w * 0.55, outlinePaint);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerBullet) {
      other.removeFromParent();
      hp -= other.damage;
      _checkPhaseTransitions();
      if (hp <= 0) {
        game.addScore(GameBalance.bossScoreReward);
        game.recordEnemyKill();
        game.recordBossDefeat();

        // Explosion effect
        parent?.add(
          ExplosionEffect(
            position: position.clone(),
            color: _coreColor,
            radius: size.x * 0.8,
          ),
        );

        removeFromParent();
        game.triggerVictory();
      }
    }
  }
}
