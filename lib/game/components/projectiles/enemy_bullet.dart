import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';

class EnemyBullet extends PositionComponent with CollisionCallbacks {
  final int damage;
  final double speed;

  EnemyBullet({
    required Vector2 startPosition,
    this.damage = GameBalance.enemyBulletDamage,
    this.speed = GameBalance.enemyBulletSpeed,
  }) : super(
         position: startPosition,
         size: Vector2(4, 10),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > (findGame()?.size.y ?? 800) + 20) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final glowPaint = Paint()
      ..color = const Color(0x40FF5252)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(2), const Radius.circular(3)),
      glowPaint,
    );
    final paint = Paint()..color = const Color(0xFFFF5252);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
  }
}
