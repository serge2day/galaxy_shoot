import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'pickup_type.dart';

class PickupItem extends PositionComponent with CollisionCallbacks {
  final PickupType type;
  double _elapsed = 0;

  PickupItem({required this.type, required Vector2 startPosition})
    : super(
        position: startPosition,
        size: Vector2(24, 24),
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
    position.y += 60 * dt;
    if (position.y > (findGame()?.size.y ?? 800) + 30) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final center = Offset(w / 2, h / 2);
    final pulse = 0.8 + sin(_elapsed * 4) * 0.2;

    // Glow
    final glowPaint = Paint()
      ..color = type.color.withValues(alpha: 0.3 * pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, w * 0.6, glowPaint);

    // Body
    final bodyPaint = Paint()..color = type.color.withValues(alpha: 0.8);
    canvas.drawCircle(center, w * 0.4 * pulse, bodyPaint);

    // Core
    final corePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(center, w * 0.15, corePaint);

    // Label
    final builder =
        ParagraphBuilder(
            ParagraphStyle(textAlign: TextAlign.center, fontSize: 10),
          )
          ..pushStyle(
            TextStyle(
              color: const Color(0xFF000000),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          )
          ..addText(type.label);
    final paragraph = builder.build();
    paragraph.layout(const ParagraphConstraints(width: 20));
    canvas.drawParagraph(paragraph, Offset(center.dx - 10, center.dy - 6));
  }
}
