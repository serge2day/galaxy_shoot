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
  final bool isElite;
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
    this.isElite = false,
    double? speed,
    int? hp,
  }) : _startX = startPosition.x,
       speed = speed ?? enemyType.baseSpeed,
       hp =
           hp ??
           (isElite
               ? (enemyType.baseHp * 2).toInt()
               : enemyType.baseHp.toInt()),
       scoreReward = isElite
           ? enemyType.scoreReward * 2
           : enemyType.scoreReward,
       super(
         position: startPosition,
         size: Vector2(
           enemyType.width * (isElite ? 1.3 : 1.0),
           enemyType.height * (isElite ? 1.3 : 1.0),
         ),
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
        position.x += speed * 0.4 * dt;
        break;
      case EnemyMovementType.swoop:
        _updateSwoop(dt);
        break;
      case EnemyMovementType.zigzag:
        position.y += speed * dt;
        // Sharp zigzag: alternate direction every 0.7s
        final phase = ((_elapsed / 0.7).floor() % 2 == 0) ? 1.0 : -1.0;
        position.x += speed * 0.6 * phase * dt;
        break;
      case EnemyMovementType.flanking:
        // Enter from side, curve inward then down
        if (_elapsed < 1.0) {
          // Curve inward
          position.x += (game.size.x / 2 - _startX) * dt * 1.2;
          position.y += speed * 0.5 * dt;
        } else {
          // Then descend with gentle sine
          position.y += speed * dt;
          position.x += sin(_elapsed * 1.5) * 50 * dt;
        }
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
      case EnemyType.swarmer:
        _renderSwarmer(canvas);
        break;
      case EnemyType.carrier:
        _renderCarrier(canvas);
        break;
    }

    // Elite indicator: brighter outer glow ring
    if (isElite) {
      final w = size.x;
      final h = size.y;
      final elitePaint = Paint()
        ..color = const Color(0x60FFD600)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, elitePaint);
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

  void _renderSwarmer(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Glow
    final glowPaint = Paint()
      ..color = enemyType.glowColor.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    // Small diamond shape
    final bodyPath = Path()
      ..moveTo(w / 2, 0) // top
      ..lineTo(w, h / 2) // right
      ..lineTo(w / 2, h) // bottom
      ..lineTo(0, h / 2) // left
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = enemyType.bodyColor);

    // Inner diamond highlight
    final corePath = Path()
      ..moveTo(w / 2, h * 0.2)
      ..lineTo(w * 0.75, h / 2)
      ..lineTo(w / 2, h * 0.8)
      ..lineTo(w * 0.25, h / 2)
      ..close();
    canvas.drawPath(corePath, Paint()..color = enemyType.glowColor);

    // Center dot
    final dotPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    canvas.drawCircle(Offset(w / 2, h / 2), 1.5, dotPaint);
  }

  void _renderCarrier(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Large glow
    final glowPaint = Paint()
      ..color = enemyType.glowColor.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, glowPaint);

    // Wide heavy ship - flat-topped with angled sides
    final bodyPath = Path()
      ..moveTo(w * 0.15, 0) // top-left
      ..lineTo(w * 0.85, 0) // top-right
      ..lineTo(w, h * 0.3) // right upper
      ..lineTo(w * 0.9, h * 0.7) // right lower
      ..lineTo(w * 0.75, h) // bottom-right
      ..lineTo(w * 0.25, h) // bottom-left
      ..lineTo(w * 0.1, h * 0.7) // left lower
      ..lineTo(0, h * 0.3) // left upper
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = enemyType.bodyColor);

    // Inner armor plating
    final corePath = Path()
      ..moveTo(w * 0.25, h * 0.1)
      ..lineTo(w * 0.75, h * 0.1)
      ..lineTo(w * 0.85, h * 0.35)
      ..lineTo(w * 0.8, h * 0.65)
      ..lineTo(w * 0.65, h * 0.9)
      ..lineTo(w * 0.35, h * 0.9)
      ..lineTo(w * 0.2, h * 0.65)
      ..lineTo(w * 0.15, h * 0.35)
      ..close();
    canvas.drawPath(corePath, Paint()..color = enemyType.glowColor);

    // Two engine glows at bottom
    final enginePaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(w * 0.35, h * 0.95), 3, enginePaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.95), 3, enginePaint);

    // Center command bridge
    final bridgePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(w / 2, h * 0.4), 3.5, bridgePaint);
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

        // Carrier special: spawn 2-3 swarmers on death
        if (enemyType == EnemyType.carrier) {
          _spawnSwarmers();
        }

        // Drop logic with evolution core focus
        _handleDrops();

        removeFromParent();
      }
    }
  }

  void _spawnSwarmers() {
    final count = 2 + _rng.nextInt(2); // 2 or 3
    for (int i = 0; i < count; i++) {
      final offset = Vector2(
        (i - 1) * 30.0 + (_rng.nextDouble() - 0.5) * 10,
        (_rng.nextDouble() - 0.5) * 10,
      );
      parent?.add(
        EnemyShip(
          startPosition: position.clone()..add(offset),
          movement: EnemyMovementType.straight,
          enemyType: EnemyType.swarmer,
        ),
      );
    }
  }

  void _handleDrops() {
    // Determine evolution core drop chance based on type and elite status
    double coreChance;
    if (isElite) {
      coreChance = 1.0; // 100% for elites
    } else {
      switch (enemyType) {
        case EnemyType.gunship:
        case EnemyType.carrier:
          coreChance = 0.40; // 40% for gunships/carriers
          break;
        default:
          coreChance = 0.20; // 20% for normal enemies
          break;
      }
    }

    if (_rng.nextDouble() < coreChance) {
      parent?.add(
        PickupItem(
          type: PickupType.evolutionCore,
          startPosition: position.clone(),
        ),
      );
      return; // Only one drop per enemy
    }

    // Small chance for other pickups (10%)
    if (_rng.nextDouble() < 0.10) {
      final otherTypes = [
        PickupType.shield,
        PickupType.heal,
        PickupType.bombCharge,
      ];
      final type = otherTypes[_rng.nextInt(otherTypes.length)];
      parent?.add(PickupItem(type: type, startPosition: position.clone()));
    }
  }
}
