import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../enemies/enemy_ship.dart';
import '../projectiles/enemy_bullet.dart';
import 'player_weapon.dart';

class PlayerShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final PlayerWeapon weapon = PlayerWeapon();

  int _hp = GameBalance.playerMaxHp;
  int get hp => _hp;

  int _lives = GameBalance.playerStartingLives;
  int get lives => _lives;

  bool _invulnerable = false;
  bool get invulnerable => _invulnerable;
  double _invulnerableTimer = 0;
  double _blinkTimer = 0;
  bool _visible = true;

  Vector2? _dragTarget;

  PlayerShip()
    : super(
        size: Vector2(
          GameBalance.playerShipWidth,
          GameBalance.playerShipHeight,
        ),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    add(weapon);
    add(RectangleHitbox(size: size * 0.7, position: size * 0.15));
    game.setHp(_hp);
    game.setLives(_lives);
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

    if (_dragTarget != null) {
      final diff = _dragTarget! - position;
      final dist = diff.length;
      if (dist > 2) {
        final move =
            diff.normalized() * min(GameBalance.playerSpeed * dt, dist);
        position.add(move);
      }
    }

    // Clamp to bounds
    final gameSize = game.size;
    final halfW = size.x / 2;
    final halfH = size.y / 2;
    position.x = position.x.clamp(halfW, gameSize.x - halfW);
    position.y = position.y.clamp(halfH, gameSize.y - halfH);
  }

  @override
  void render(Canvas canvas) {
    if (!_visible) return;

    final w = size.x;
    final h = size.y;

    // Ship glow
    final glowPaint = Paint()
      ..color = const Color(0x2000E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.6, glowPaint);

    // Ship body
    final bodyPath = Path()
      ..moveTo(w / 2, 0) // nose
      ..lineTo(w * 0.85, h * 0.7)
      ..lineTo(w, h)
      ..lineTo(w * 0.6, h * 0.75)
      ..lineTo(w * 0.4, h * 0.75)
      ..lineTo(0, h)
      ..lineTo(w * 0.15, h * 0.7)
      ..close();

    final bodyPaint = Paint()..color = const Color(0xFF00B8D4);
    canvas.drawPath(bodyPath, bodyPaint);

    // Highlight stripe
    final stripePath = Path()
      ..moveTo(w / 2, h * 0.1)
      ..lineTo(w * 0.6, h * 0.65)
      ..lineTo(w * 0.4, h * 0.65)
      ..close();
    final stripePaint = Paint()..color = const Color(0xFF00E5FF);
    canvas.drawPath(stripePath, stripePaint);

    // Engine glow
    final enginePaint = Paint()
      ..color = const Color(0xFFFF9100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(w * 0.35, h * 0.85), 3, enginePaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.85), 3, enginePaint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_invulnerable) return;

    if (other is EnemyBullet) {
      other.removeFromParent();
      takeDamage(other.damage);
    } else if (other is EnemyShip) {
      takeDamage(2);
    }
  }

  void takeDamage(int amount) {
    if (_invulnerable) return;
    _hp -= amount;
    game.setHp(_hp);

    if (_hp <= 0) {
      _lives--;
      game.setLives(_lives);
      if (_lives <= 0) {
        game.triggerGameOver();
      } else {
        _hp = GameBalance.playerMaxHp;
        game.setHp(_hp);
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
