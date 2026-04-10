import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../galaxy_game.dart';
import '../effects/explosion_effect.dart';
import '../projectiles/player_bullet.dart';

/// Large rotating dead satellite piece. Takes multiple hits.
class SatelliteDebris extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final double speed;
  int hp;
  double _angle = 0;
  final double _rotSpeed;

  static final Random _rng = Random();

  SatelliteDebris({
    required Vector2 startPosition,
    this.speed = 40,
    this.hp = 5,
  }) : _rotSpeed = 0.3 + _rng.nextDouble() * 0.8,
       super(
         position: startPosition,
         size: Vector2(44, 36),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    _angle = _rng.nextDouble() * 3.14;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    _angle += _rotSpeed * dt;
    if (position.y > (game.size.y + 50)) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final cx = w / 2;
    final cy = h / 2;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_angle);
    canvas.translate(-cx, -cy);

    // Solar panel left
    canvas.drawRect(
      Rect.fromLTWH(0, cy - 4, w * 0.3, 8),
      Paint()..color = const Color(0xFF1565C0),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, cy - 4, w * 0.3, 8),
      Paint()
        ..color = const Color(0xFF42A5F5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Solar panel right
    canvas.drawRect(
      Rect.fromLTWH(w * 0.7, cy - 4, w * 0.3, 8),
      Paint()..color = const Color(0xFF1565C0),
    );

    // Main body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.3, cy - 8, w * 0.4, 16),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF78909C),
    );

    // Antenna
    canvas.drawLine(
      Offset(cx, cy - 8),
      Offset(cx + 4, cy - 16),
      Paint()
        ..color = const Color(0xFFB0BEC5)
        ..strokeWidth = 1,
    );

    // Damage marks
    if (hp < 3) {
      canvas.drawLine(
        Offset(w * 0.35, cy - 5),
        Offset(w * 0.55, cy + 5),
        Paint()
          ..color = const Color(0x60FF5252)
          ..strokeWidth = 1,
      );
    }

    canvas.restore();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerBullet) {
      other.removeFromParent();
      hp--;
      if (hp <= 0) {
        parent?.add(
          ExplosionEffect(
            position: position.clone(),
            color: const Color(0xFF90A4AE),
            radius: 30,
          ),
        );
        removeFromParent();
      }
    }
  }
}
