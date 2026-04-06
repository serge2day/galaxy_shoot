import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

/// Non-collidable visual debris that drifts through the playfield.
/// Adds life to the space environment without gameplay impact.
class SpaceDebris extends PositionComponent {
  final double speed;
  final double rotSpeed;
  final int _variant;
  double _angle = 0;

  static final Random _rng = Random();

  SpaceDebris({
    required Vector2 startPosition,
    double? speed,
    double debrisSize = 12,
  })  : speed = speed ?? 40 + _rng.nextDouble() * 40,
        rotSpeed = 0.5 + _rng.nextDouble() * 2,
        _variant = _rng.nextInt(4),
        super(
          position: startPosition,
          size: Vector2.all(debrisSize),
          anchor: Anchor.center,
        ) {
    _angle = _rng.nextDouble() * 6.28;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    _angle += rotSpeed * dt;
    if (position.y > (findGame()?.size.y ?? 800) + 20) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final r = size.x / 2;
    final cx = r;
    final cy = r;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(_angle);
    canvas.translate(-cx, -cy);

    final Color color;
    switch (_variant) {
      case 0:
        color = const Color(0x40607D8B);
        break;
      case 1:
        color = const Color(0x30795548);
        break;
      case 2:
        color = const Color(0x35546E7A);
        break;
      default:
        color = const Color(0x30455A64);
    }

    // Small irregular shape
    final path = Path();
    const sides = 5;
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 3.14159 * 2;
      final v = 0.6 + (i % 2) * 0.4;
      final px = cx + cos(angle) * r * v;
      final py = cy + sin(angle) * r * v;
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);

    canvas.restore();
  }
}
