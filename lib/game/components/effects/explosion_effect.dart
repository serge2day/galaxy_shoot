import 'dart:ui';

import 'package:flame/components.dart';

class ExplosionEffect extends PositionComponent {
  final Color color;
  double _elapsed = 0;
  static const double duration = 0.3;

  ExplosionEffect({
    required Vector2 position,
    this.color = const Color(0xFFFF5252),
    double radius = 20,
  }) : super(
         position: position,
         size: Vector2.all(radius * 2),
         anchor: Anchor.center,
       );

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
    final radius = size.x / 2;

    // Expanding ring
    final ringRadius = radius * progress;
    final ringAlpha = (1.0 - progress) * 0.8;
    final ringPaint = Paint()
      ..color = color.withValues(alpha: ringAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * (1.0 - progress);
    canvas.drawCircle(Offset(radius, radius), ringRadius, ringPaint);

    // Core flash
    if (progress < 0.5) {
      final coreAlpha = (1.0 - progress * 2) * 0.6;
      final corePaint = Paint()
        ..color = const Color(0xFFFFFFFF).withValues(alpha: coreAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(
        Offset(radius, radius),
        radius * 0.3 * (1.0 - progress),
        corePaint,
      );
    }
  }
}
