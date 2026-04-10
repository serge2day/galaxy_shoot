import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../../../core/config/game_balance.dart';
import '../../../features/hangar/domain/ship_definition.dart';
import '../../../features/hangar/domain/ship_stats.dart';
import '../../galaxy_game.dart';
import '../../../core/services/game_audio.dart';
import '../../../core/services/game_haptics.dart';
import '../enemies/enemy_ship.dart';
import '../obstacles/asteroid.dart';
import '../obstacles/satellite_debris.dart';
import '../obstacles/space_mine.dart';
import '../pickups/pickup_item.dart';
import '../pickups/pickup_type.dart';
import '../projectiles/enemy_bullet.dart';
import 'player_weapon.dart';

class PlayerShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  late final PlayerWeapon weapon;
  final ShipStats stats;
  final ShipVisualStyle visualStyle;
  final String shipId;

  late int _hp;
  int get hp => _hp;

  late int _lives;
  int get lives => _lives;

  bool _invulnerable = false;
  bool get invulnerable => _invulnerable;
  double _invulnerableTimer = 0;
  double _blinkTimer = 0;
  bool _visible = true;

  bool _shielded = false;
  double _shieldTimer = 0;

  Vector2? _dragTarget;

  ui.Image? _spriteImage;

  PlayerShip({
    required this.stats,
    this.visualStyle = ShipVisualStyle.balanced,
    this.shipId = 'vanguard',
  }) : super(
         size: Vector2(stats.shipWidth, stats.shipHeight),
         anchor: Anchor.center,
       ) {
    _hp = stats.maxHp;
    _lives = stats.startingLives;
    weapon = PlayerWeapon(
      cooldown: stats.fireCooldown,
      damage: stats.bulletDamage,
    );
  }

  @override
  Future<void> onLoad() async {
    add(weapon);
    add(
      RectangleHitbox(
        size: size * stats.hitboxScale,
        position: size * ((1 - stats.hitboxScale) / 2),
      ),
    );
    // If game already has HP/lives set (carry-over from previous mission),
    // use those values instead of defaults
    if (game.hp > 0 && game.lives > 0) {
      _hp = game.hp;
      _lives = game.lives;
    } else {
      game.setHp(_hp);
      game.setLives(_lives);
    }

    // Try to load ship sprite
    try {
      final data = await rootBundle.load(
        'assets/images/ship_${shipId}_game.png',
      );
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      _spriteImage = frame.image;
    } catch (_) {
      // No sprite found, will use canvas drawing
    }
  }

  void moveTo(Vector2 target) {
    _dragTarget = target;
  }

  void stopMoving() {
    _dragTarget = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_invulnerable) {
      _invulnerableTimer -= dt;
      _blinkTimer += dt;
      _visible = ((_blinkTimer * 10).toInt() % 2) == 0;
      if (_invulnerableTimer <= 0) {
        _invulnerable = false;
        _visible = true;
      }
    }

    if (_shielded) {
      _shieldTimer -= dt;
      if (_shieldTimer <= 0) {
        _shielded = false;
      }
    }

    if (_dragTarget != null) {
      final diff = _dragTarget! - position;
      final dist = diff.length;
      if (dist > 2) {
        final move = diff.normalized() * min(stats.speed * dt, dist);
        position.add(move);
      }
    }

    final gameSize = game.size;
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    position.x = position.x.clamp(halfW, gameSize.x - halfW);
    position.y = position.y.clamp(halfH, gameSize.y - halfH);
  }

  @override
  void render(Canvas canvas) {
    if (!_visible) return;

    // Apply evolution scale
    final evoScale = game.evolution.getShipScale();
    if (evoScale != 1.0) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.scale(evoScale);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    // Overdrive glow
    if (game.evolution.isOverdriveActive) {
      final glow = Paint()
        ..color = const Color(0x40FFD600)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.8, glow);
    }

    if (_spriteImage != null) {
      _renderSprite(canvas);
    } else {
      switch (visualStyle) {
        case ShipVisualStyle.balanced:
        case ShipVisualStyle.guardian:
        case ShipVisualStyle.ravager:
          _renderBalanced(canvas);
          break;
        case ShipVisualStyle.striker:
        case ShipVisualStyle.phantom:
          _renderSwift(canvas);
          break;
        case ShipVisualStyle.titan:
          _renderHeavy(canvas);
          break;
      }
    }

    if (evoScale != 1.0) {
      canvas.restore();
    }

    // Shield overlay
    if (_shielded) {
      final center = Offset(size.x / 2, size.y / 2);
      final radius = size.x * 0.7;
      final shieldPaint = Paint()
        ..color = const Color(0x4000B0FF)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, shieldPaint);
      final shieldBorder = Paint()
        ..color = const Color(0xAA00B0FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(center, radius, shieldBorder);
    }
  }

  void _renderSprite(Canvas canvas) {
    final img = _spriteImage!;
    final src = Rect.fromLTWH(
      0,
      0,
      img.width.toDouble(),
      img.height.toDouble(),
    );
    final dst = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawImageRect(img, src, dst, Paint());

    // Engine glow underneath sprite
    final enginePaint = Paint()
      ..color = const Color(0xFFFF9100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(size.x * 0.35, size.y * 0.9), 3, enginePaint);
    canvas.drawCircle(Offset(size.x * 0.65, size.y * 0.9), 3, enginePaint);
  }

  void _renderBalanced(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = const Color(0x2000E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, glowPaint);

    final bodyPath = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w * 0.85, h * 0.7)
      ..lineTo(w, h)
      ..lineTo(w * 0.6, h * 0.75)
      ..lineTo(w * 0.4, h * 0.75)
      ..lineTo(0, h)
      ..lineTo(w * 0.15, h * 0.7)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFF00B8D4));

    final stripePath = Path()
      ..moveTo(w / 2, h * 0.1)
      ..lineTo(w * 0.6, h * 0.65)
      ..lineTo(w * 0.4, h * 0.65)
      ..close();
    canvas.drawPath(stripePath, Paint()..color = const Color(0xFF00E5FF));

    final enginePaint = Paint()
      ..color = const Color(0xFFFF9100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(w * 0.35, h * 0.85), 3, enginePaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.85), 3, enginePaint);
  }

  void _renderSwift(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = const Color(0x2000FF88)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    // Sleek narrow shape
    final bodyPath = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w * 0.9, h * 0.6)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.55, h * 0.7)
      ..lineTo(w * 0.45, h * 0.7)
      ..lineTo(w * 0.25, h)
      ..lineTo(w * 0.1, h * 0.6)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFF00C853));

    final stripePath = Path()
      ..moveTo(w / 2, h * 0.05)
      ..lineTo(w * 0.58, h * 0.55)
      ..lineTo(w * 0.42, h * 0.55)
      ..close();
    canvas.drawPath(stripePath, Paint()..color = const Color(0xFF69F0AE));

    final enginePaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(w * 0.4, h * 0.85), 2.5, enginePaint);
    canvas.drawCircle(Offset(w * 0.6, h * 0.85), 2.5, enginePaint);
  }

  void _renderHeavy(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final glowPaint = Paint()
      ..color = const Color(0x20FF9100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, glowPaint);

    // Wide bulky shape
    final bodyPath = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w * 0.95, h * 0.5)
      ..lineTo(w, h * 0.85)
      ..lineTo(w * 0.7, h)
      ..lineTo(w * 0.3, h)
      ..lineTo(0, h * 0.85)
      ..lineTo(w * 0.05, h * 0.5)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFE65100));

    final corePath = Path()
      ..moveTo(w / 2, h * 0.1)
      ..lineTo(w * 0.7, h * 0.5)
      ..lineTo(w * 0.65, h * 0.85)
      ..lineTo(w * 0.35, h * 0.85)
      ..lineTo(w * 0.3, h * 0.5)
      ..close();
    canvas.drawPath(corePath, Paint()..color = const Color(0xFFFF9100));

    final enginePaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(w * 0.3, h * 0.92), 4, enginePaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.95), 4, enginePaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.92), 4, enginePaint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // Pickups can be collected regardless of invulnerability
    if (other is PickupItem) {
      other.removeFromParent();
      _applyPickup(other.type);
      return;
    }

    if (_invulnerable) return;

    if (other is EnemyBullet) {
      other.removeFromParent();
      if (_shielded) return;
      takeDamage(other.damage);
    } else if (other is EnemyShip) {
      if (_shielded) return;
      takeDamage(2);
    } else if (other is Asteroid) {
      if (_shielded) return;
      takeDamage(1);
    } else if (other is SpaceMine) {
      other.removeFromParent();
      if (_shielded) return;
      takeDamage(2);
    } else if (other is SatelliteDebris) {
      if (_shielded) return;
      takeDamage(1);
    }
  }

  void _applyPickup(PickupType type) {
    GameAudio.pickupCollect();
    GameHaptics.pickupCollect();
    switch (type) {
      case PickupType.evolutionCore:
        final evolved = game.collectEvolutionCore();
        if (evolved) {
          GameAudio.evolutionUp();
          GameHaptics.evolutionUp();
        }
        break;
      case PickupType.shield:
        _shielded = true;
        _shieldTimer = 15.0;
        break;
      case PickupType.heal:
        _hp = stats.maxHp;
        game.setHp(_hp);
        break;
      case PickupType.bombCharge:
        game.bomb.addCharge();
        break;
    }
  }

  void takeDamage(int amount) {
    if (_invulnerable) return;
    _hp -= amount;
    game.setHp(_hp);
    GameAudio.playerDamage();
    GameHaptics.playerDamage();

    if (_hp <= 0) {
      _lives--;
      game.setLives(_lives);
      if (_lives <= 0) {
        GameAudio.playerDeath();
        GameHaptics.playerDeath();
        game.triggerGameOver();
      } else {
        GameAudio.playerDeath();
        GameHaptics.playerDeath();
        _hp = stats.maxHp;
        game.setHp(_hp);
        game.evolution.dropLevel();
        _startInvulnerability();
      }
    } else {
      _startInvulnerability();
    }
  }

  void _startInvulnerability() {
    _invulnerable = true;
    _invulnerableTimer = GameBalance.playerInvulnerabilityDuration;
    _blinkTimer = 0;
  }
}
