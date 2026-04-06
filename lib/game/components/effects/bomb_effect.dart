import 'dart:ui';

import 'package:flame/components.dart';

import '../enemies/enemy_ship.dart';
import '../projectiles/enemy_bullet.dart';

/// Full-screen expanding white ring that damages enemies and clears bullets.
/// Duration 0.5s. Expands from player position outward.
class BombEffect extends PositionComponent with HasGameReference {
  double _elapsed = 0;
  static const double duration = 0.5;
  final double maxRadius;
  bool _damageDone = false;

  BombEffect({required Vector2 position, this.maxRadius = 600})
    : super(
        position: position,
        size: Vector2.all(maxRadius * 2),
        anchor: Anchor.center,
      );

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    // Damage enemies and clear bullets when the ring reaches them
    if (!_damageDone && _elapsed >= duration * 0.3) {
      _damageDone = true;
      _clearEnemiesAndBullets();
    }

    if (_elapsed >= duration) {
      removeFromParent();
    }
  }

  void _clearEnemiesAndBullets() {
    final parentComp = parent;
    if (parentComp == null) return;

    // Remove all enemy bullets
    final bulletsToRemove = <EnemyBullet>[];
    parentComp.children.whereType<EnemyBullet>().forEach((bullet) {
      bulletsToRemove.add(bullet);
    });
    for (final bullet in bulletsToRemove) {
      bullet.removeFromParent();
    }

    // Damage all enemies with 999 damage
    final enemiesToDamage = <EnemyShip>[];
    parentComp.children.whereType<EnemyShip>().forEach((enemy) {
      enemiesToDamage.add(enemy);
    });
    for (final enemy in enemiesToDamage) {
      enemy.hp = 0;
      // We simulate death by setting HP to 0; the enemy's next collision
      // or we can just remove them. For simplicity, remove directly
      // and award score.
      enemy.removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / duration).clamp(0.0, 1.0);
    final center = Offset(size.x / 2, size.y / 2);
    final currentRadius = maxRadius * progress;

    // Expanding white ring
    final ringAlpha = (1.0 - progress) * 0.9;
    final ringWidth = 8.0 * (1.0 - progress * 0.5);
    final ringPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, ringAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    canvas.drawCircle(center, currentRadius, ringPaint);

    // Inner glow behind the ring
    if (progress < 0.6) {
      final glowAlpha = (1.0 - progress / 0.6) * 0.3;
      final glowPaint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, glowAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(center, currentRadius * 0.7, glowPaint);
    }

    // Central flash at start
    if (progress < 0.2) {
      final flashAlpha = (1.0 - progress / 0.2) * 0.8;
      final flashPaint = Paint()
        ..color = Color.fromRGBO(255, 255, 240, flashAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, 30 * (1.0 - progress), flashPaint);
    }
  }
}
