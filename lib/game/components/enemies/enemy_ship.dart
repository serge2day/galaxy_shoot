import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../../world/stages/stage_definition.dart';
import '../effects/explosion_effect.dart';
import '../effects/hit_flash.dart';
import '../pickups/pickup_item.dart';
import '../pickups/pickup_type.dart';
import '../projectiles/player_bullet.dart';
import 'enemy_type.dart';
import 'enemy_weapon.dart';

class EnemyShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final EnemyMovementType movement;
  final EnemyType enemyType;
  final double speed;
  final int scoreReward;
  int hp;
  final double _startX;
  double _elapsed = 0;

  // Swoop movement state
  bool _swoopDipping = true;
  double _swoopTargetX = 0;

  static final Random _rng = Random();

  EnemyShip({
    required Vector2 startPosition,
    this.movement = EnemyMovementType.straight,
    this.enemyType = EnemyType.drone,
    double? speed,
    int? hp,
  }) : _startX = startPosition.x,
       speed = speed ?? enemyType.baseSpeed,
       hp = hp ?? enemyType.baseHp.toInt(),
       scoreReward = enemyType.scoreReward,
       super(
         position: startPosition,
         size: Vector2(enemyType.width, enemyType.height),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    final cooldownMod = game.difficultyModifiers.enemyFireRateMultiplier;
    add(EnemyWeapon(cooldown: enemyType.baseFireCooldown * cooldownMod));
    add(RectangleHitbox(size: size * 0.8, position: size * 0.1));
    // Apply difficulty HP multiplier
    hp = (hp * game.difficultyModifiers.enemyHpMultiplier).ceil();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    switch (movement) {
      case EnemyMovementType.straight:
        position.y += speed * dt;
        break;
      case EnemyMovementType.sineWave:
        position.y += speed * dt;
        position.x =
            _startX +
            sin(_elapsed * GameBalance.enemySineFrequency) *
                GameBalance.enemySineAmplitude;
        break;
      case EnemyMovementType.diagonal:
        position.y += speed * dt;
        position.x += speed * 0.3 * dt;
        break;
      case EnemyMovementType.swoop:
        _updateSwoop(dt);
        break;
    }

    if (position.y > (game.size.y + 60)) {
      removeFromParent();
    }
  }

  void _updateSwoop(double dt) {
    if (_swoopDipping) {
      // Dip down quickly
      position.y += speed * 1.5 * dt;
      if (position.y >= game.size.y * 0.4) {
        _swoopDipping = false;
        // Target the player's general x-area with some randomness
        final playerChildren = game.galaxyWorld.children;
        _swoopTargetX = game.size.x / 2; // fallback
        for (final child in playerChildren) {
          if (child is PositionComponent &&
              child.runtimeType.toString().contains('Player')) {
            _swoopTargetX = child.position.x + (_rng.nextDouble() - 0.5) * 60;
            break;
          }
        }
      }
    } else {
      // Angle toward player x while continuing downward
      final dx = _swoopTargetX - position.x;
      position.x += dx.clamp(-speed * 0.8, speed * 0.8) * dt;
      position.y += speed * 0.6 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    switch (enemyType) {
      case EnemyType.drone:
        _renderDrone(canvas);
        break;
      case EnemyType.interceptor:
        _renderInterceptor(canvas);
        break;
      case EnemyType.gunship:
        _renderGunship(canvas);
        break;
    }
  }

  void _renderDrone(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = enemyType.glowColor.withValues(alpha: 0.125)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    // Inverted triangle
    final bodyPath = Path()
      ..moveTo(w / 2, h)
      ..lineTo(w, 0)
      ..lineTo(w * 0.7, h * 0.3)
      ..lineTo(w * 0.3, h * 0.3)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = enemyType.bodyColor);

    final corePath = Path()
      ..moveTo(w / 2, h * 0.85)
      ..lineTo(w * 0.7, h * 0.15)
      ..lineTo(w * 0.3, h * 0.15)
      ..close();
    canvas.drawPath(corePath, Paint()..color = enemyType.glowColor);
  }

  void _renderInterceptor(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = enemyType.glowColor.withValues(alpha: 0.125)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    // Arrow / chevron shape pointing downward
    final bodyPath = Path()
      ..moveTo(w / 2, h) // bottom tip
      ..lineTo(w, h * 0.2)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w / 2, h * 0.35)
      ..lineTo(w * 0.25, 0)
      ..lineTo(0, h * 0.2)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = enemyType.bodyColor);

    // Inner chevron highlight
    final corePath = Path()
      ..moveTo(w / 2, h * 0.85)
      ..lineTo(w * 0.75, h * 0.25)
      ..lineTo(w / 2, h * 0.45)
      ..lineTo(w * 0.25, h * 0.25)
      ..close();
    canvas.drawPath(corePath, Paint()..color = enemyType.glowColor);

    // Engine glow
    final enginePaint = Paint()
      ..color = const Color(0xFFFFD600)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(w * 0.3, h * 0.1), 2.5, enginePaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.1), 2.5, enginePaint);
  }

  void _renderGunship(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = enemyType.glowColor.withValues(alpha: 0.125)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.55, glowPaint);

    // Wide bulky hexagonal shape
    final bodyPath = Path()
      ..moveTo(w * 0.3, 0)
      ..lineTo(w * 0.7, 0)
      ..lineTo(w, h * 0.35)
      ..lineTo(w, h * 0.65)
      ..lineTo(w * 0.7, h)
      ..lineTo(w * 0.3, h)
      ..lineTo(0, h * 0.65)
      ..lineTo(0, h * 0.35)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = enemyType.bodyColor);

    // Inner hexagonal core
    final corePath = Path()
      ..moveTo(w * 0.35, h * 0.15)
      ..lineTo(w * 0.65, h * 0.15)
      ..lineTo(w * 0.8, h * 0.4)
      ..lineTo(w * 0.8, h * 0.6)
      ..lineTo(w * 0.65, h * 0.85)
      ..lineTo(w * 0.35, h * 0.85)
      ..lineTo(w * 0.2, h * 0.6)
      ..lineTo(w * 0.2, h * 0.4)
      ..close();
    canvas.drawPath(corePath, Paint()..color = enemyType.glowColor);

    // Center eye
    final eyePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(w / 2, h / 2), 3, eyePaint);
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

      // Hit flash effect
      parent?.add(HitFlash(position: position.clone()));

      if (hp <= 0) {
        game.addScore(scoreReward);
        game.recordEnemyKill();

        // Explosion effect
        parent?.add(
          ExplosionEffect(
            position: position.clone(),
            color: enemyType.glowColor,
            radius: size.x * 0.6,
          ),
        );

        // 15% chance to drop a pickup
        if (_rng.nextDouble() < 0.15) {
          final pickupTypes = PickupType.values;
          final type = pickupTypes[_rng.nextInt(pickupTypes.length)];
          parent?.add(PickupItem(type: type, startPosition: position.clone()));
        }

        removeFromParent();
      }
    }
  }
}
