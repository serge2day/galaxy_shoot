import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../galaxy_game.dart';
import '../effects/explosion_effect.dart';
import '../projectiles/player_bullet.dart';

class Asteroid extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final double speed;
  final int hp;
  final double asteroidSize;
  int _currentHp;
  double _angle = 0;
  final int _variant;

  static final Random _rng = Random();

  Asteroid({
    required Vector2 startPosition,
    this.speed = 80,
    this.hp = 3,
    this.asteroidSize = 30,
  })  : _currentHp = hp,
        _variant = _rng.nextInt(3),
        super(
          position: startPosition,
          size: Vector2.all(asteroidSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    _angle = _rng.nextDouble() * 3.14;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    _angle += rotationSpeed * dt;
    if (position.y > (game.size.y + 60)) {
      removeFromParent();
    }
  }

  double get rotationSpeed => 0.8 + _variant * 0.5;

  @override
  void render(Canvas canvas) {
    final r = size.x / 2;
    final cx = r;
    final cy = r;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_angle);
    canvas.translate(-cx, -cy);

    // Rocky body
    final bodyColor = _variant == 0
        ? const Color(0xFF5D4037)
        : _variant == 1
            ? const Color(0xFF455A64)
            : const Color(0xFF4E342E);

    final path = Path();
    const sides = 7;
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 3.14159 * 2;
      final variation = 0.7 + _rng.nextDouble() * 0.3;
      final px = cx + cos(angle) * r * variation;
      final py = cy + sin(angle) * r * variation;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = bodyColor);

    // Highlight edge
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x30FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Crater spots
    canvas.drawCircle(
      Offset(cx - r * 0.2, cy - r * 0.1),
      r * 0.15,
      Paint()..color = const Color(0x20000000),
    );
    canvas.drawCircle(
      Offset(cx + r * 0.25, cy + r * 0.2),
      r * 0.12,
      Paint()..color = const Color(0x20000000),
    );

    canvas.restore();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // Player bullets damage asteroids
    if (other is PlayerBullet) {
      other.removeFromParent();
      _currentHp--;
      if (_currentHp <= 0) {
        parent?.add(ExplosionEffect(
          position: position.clone(),
          color: const Color(0xFF8D6E63),
          radius: asteroidSize * 0.6,
        ));
        removeFromParent();
      }
    }
  }
}
