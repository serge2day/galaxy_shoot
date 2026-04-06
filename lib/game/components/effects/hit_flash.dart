import 'dart:ui';

import 'package:flame/components.dart';

class HitFlash extends PositionComponent {
  double _elapsed = 0;
  static const double duration = 0.12;

  HitFlash({required Vector2 position})
    : super(position: position, size: Vector2.all(16), anchor: Anchor.center);

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
    final alpha = (1.0 - progress) * 0.9;
    final radius = size.x / 2 * (0.5 + progress * 0.5);

    final paint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, alpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), radius, paint);
  }
}
