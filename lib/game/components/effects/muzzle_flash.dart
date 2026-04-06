import 'dart:ui';

import 'package:flame/components.dart';

/// Short bright flash at the weapon muzzle position.
/// Slightly yellow-white, smaller and quicker than a hit flash.
class MuzzleFlash extends PositionComponent {
  double _elapsed = 0;
  static const double duration = 0.08;

  MuzzleFlash({required Vector2 position})
    : super(position: position, size: Vector2.all(12), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final alpha = (1.0 - progress) * 0.95;
    final radius = size.x / 2 * (0.4 + progress * 0.6);
    final center = Offset(size.x / 2, size.y / 2);

    // Outer yellow-white glow
    final glowPaint = Paint()
      ..color = Color.fromRGBO(255, 245, 180, alpha * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, radius * 1.4, glowPaint);

    // Core bright white
    final corePaint = Paint()
      ..color = Color.fromRGBO(255, 255, 240, alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center, radius * 0.6, corePaint);
  }
}
