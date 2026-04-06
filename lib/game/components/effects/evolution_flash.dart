import 'dart:ui';

import 'package:flame/components.dart';

/// A brief full-ship glow pulse when evolution level increases.
/// Bigger and more dramatic than hit_flash. Cyan/white, 0.4s duration.
class EvolutionFlash extends PositionComponent {
  double _elapsed = 0;
  static const double duration = 0.4;

  EvolutionFlash({required Vector2 position})
    : super(position: position, size: Vector2.all(80), anchor: Anchor.center);

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
    final center = Offset(size.x / 2, size.y / 2);

    // Expanding cyan ring
    final ringRadius = size.x / 2 * (0.3 + progress * 0.7);
    final ringAlpha = (1.0 - progress) * 0.7;
    final ringPaint = Paint()
      ..color = Color.fromRGBO(0, 229, 255, ringAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * (1.0 - progress);
    canvas.drawCircle(center, ringRadius, ringPaint);

    // Outer glow halo
    final glowAlpha = (1.0 - progress) * 0.4;
    final glowPaint = Paint()
      ..color = Color.fromRGBO(0, 229, 255, glowAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, ringRadius * 0.8, glowPaint);

    // Inner white core flash (fades faster)
    if (progress < 0.5) {
      final coreProgress = progress / 0.5;
      final coreAlpha = (1.0 - coreProgress) * 0.9;
      final coreRadius = size.x * 0.25 * (1.0 - coreProgress * 0.5);
      final corePaint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, coreAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, coreRadius, corePaint);
    }
  }
}
