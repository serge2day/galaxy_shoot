import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../galaxy_game.dart';
import '../effects/explosion_effect.dart';
import '../projectiles/player_bullet.dart';

/// Glowing space mine that explodes on contact.
class SpaceMine extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final double speed;
  double _elapsed = 0;
  bool _exploded = false;

  SpaceMine({required Vector2 startPosition, this.speed = 50})
    : super(
        position: startPosition,
        size: Vector2.all(22),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    position.y += speed * dt;
    if (position.y > (game.size.y + 30)) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final r = size.x / 2;
    final cx = r;
    final cy = r;
    final pulse = (sin(_elapsed * 5) + 1) / 2;

    // Danger glow
    final glowPaint = Paint()
      ..color = Color.fromRGBO(255, 0, 0, 0.2 + pulse * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(cx, cy), r * 1.3, glowPaint);

    // Mine body - dark metallic
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.7,
      Paint()..color = const Color(0xFF37474F),
    );

    // Spikes
    final spikePaint = Paint()
      ..color = const Color(0xFF546E7A)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 3.14159 * 2;
      final inner = r * 0.6;
      final outer = r * 0.95;
      canvas.drawLine(
        Offset(cx + cos(angle) * inner, cy + sin(angle) * inner),
        Offset(cx + cos(angle) * outer, cy + sin(angle) * outer),
        spikePaint,
      );
    }

    // Blinking red center
    final centerPaint = Paint()
      ..color = Color.fromRGBO(255, 23, 68, 0.5 + pulse * 0.5);
    canvas.drawCircle(Offset(cx, cy), r * 0.25, centerPaint);
  }

  void _explode() {
    if (_exploded) return;
    _exploded = true;
    parent?.add(
      ExplosionEffect(
        position: position.clone(),
        color: const Color(0xFFFF1744),
        radius: 40,
      ),
    );
    removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerBullet) {
      other.removeFromParent();
      _explode();
    }
  }
}
