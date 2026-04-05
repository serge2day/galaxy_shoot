import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../projectiles/player_bullet.dart';
import 'boss_weapon.dart';

enum BossPhase { entering, phase1, phase2 }

class BossShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  late int hp;
  late int maxHp;
  BossPhase phase = BossPhase.entering;

  late BossWeapon _weapon;
  double _elapsed = 0;
  final double _targetY = 80;

  BossShip({required Vector2 startPosition})
    : super(
        position: startPosition,
        size: Vector2(GameBalance.bossWidth, GameBalance.bossHeight),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    final mods = game.difficultyModifiers;
    maxHp = (GameBalance.bossHp * mods.bossHpMultiplier).ceil();
    hp = maxHp;

    final baseCooldown =
        GameBalance.bossFireCooldown * mods.bossFireRateMultiplier;
    _weapon = BossWeapon(cooldown: baseCooldown);
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
        _checkPhaseTransition();
        break;
      case BossPhase.phase2:
        _movePhase2(dt);
        break;
    }
  }

  void _movePhase1(double dt) {
    final gameWidth = game.size.x;
    position.x = gameWidth / 2 + sin(_elapsed * 0.8) * (gameWidth * 0.3);
  }

  void _movePhase2(double dt) {
    final gameWidth = game.size.x;
    position.x = gameWidth / 2 + sin(_elapsed * 1.5) * (gameWidth * 0.35);
    position.y = _targetY + sin(_elapsed * 2.0) * 20;
  }

  void _checkPhaseTransition() {
    if (hp <= maxHp * GameBalance.bossPhase2HpRatio) {
      phase = BossPhase.phase2;
      final mods = game.difficultyModifiers;
      _weapon.cooldown =
          GameBalance.bossPhase2FireCooldown * mods.bossFireRateMultiplier;
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowColor = phase == BossPhase.phase2
        ? const Color(0x30FF1744)
        : const Color(0x207C4DFF);
    final glowPaint = Paint()
      ..color = glowColor
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

    final bodyColor = phase == BossPhase.phase2
        ? const Color(0xFFD50000)
        : const Color(0xFF6A1B9A);
    canvas.drawPath(bodyPath, Paint()..color = bodyColor);

    final corePath = Path()
      ..moveTo(w / 2, h * 0.2)
      ..lineTo(w * 0.75, h * 0.45)
      ..lineTo(w * 0.65, h * 0.8)
      ..lineTo(w * 0.35, h * 0.8)
      ..lineTo(w * 0.25, h * 0.45)
      ..close();

    final coreColor = phase == BossPhase.phase2
        ? const Color(0xFFFF5252)
        : const Color(0xFF9C27B0);
    canvas.drawPath(corePath, Paint()..color = coreColor);

    final eyePaint = Paint()
      ..color = const Color(0xFFFFFF00)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(w / 2, h * 0.4), 5, eyePaint);
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
      if (phase == BossPhase.phase1) {
        _checkPhaseTransition();
      }
      if (hp <= 0) {
        game.addScore(GameBalance.bossScoreReward);
        game.recordEnemyKill();
        game.recordBossDefeat();
        removeFromParent();
        game.triggerVictory();
      }
    }
  }
}
