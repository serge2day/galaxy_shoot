import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';

class PlayerBullet extends PositionComponent with CollisionCallbacks {
  final int damage;

  PlayerBullet({
    required Vector2 startPosition,
    this.damage = GameBalance.playerBulletDamage,
  }) : super(
         position: startPosition,
         size: Vector2(
           GameBalance.playerBulletWidth,
           GameBalance.playerBulletHeight,
         ),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= GameBalance.playerBulletSpeed * dt;
    if (position.y < -20) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // Glowing cyan bullet
    final rect = size.toRect();
    final glowPaint = Paint()
      ..color = const Color(0x4000E5FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(3), const Radius.circular(4)),
      glowPaint,
    );
    final paint = Paint()..color = const Color(0xFF00E5FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
    final corePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(1)),
      corePaint,
    );
  }
}
