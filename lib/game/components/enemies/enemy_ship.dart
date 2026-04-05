import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../projectiles/player_bullet.dart';
import 'enemy_weapon.dart';

enum EnemyMovement { straight, sineWave, diagonal }

class EnemyShip extends PositionComponent
    with CollisionCallbacks, HasGameReference<GalaxyGame> {
  final EnemyMovement movement;
  final double speed;
  final int scoreReward;
  int hp;
  final double _startX;
  double _elapsed = 0;

  EnemyShip({
    required Vector2 startPosition,
    this.movement = EnemyMovement.straight,
    this.speed = GameBalance.enemySpeed,
    this.hp = GameBalance.enemyHp,
    this.scoreReward = GameBalance.enemyScoreReward,
  }) : _startX = startPosition.x,
       super(
         position: startPosition,
         size: Vector2(GameBalance.enemyShipWidth, GameBalance.enemyShipHeight),
         anchor: Anchor.center,
       );

  @override
  Future<void> onLoad() async {
    add(EnemyWeapon());
    add(RectangleHitbox(size: size * 0.8, position: size * 0.1));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    position.y += speed * dt;

    switch (movement) {
      case EnemyMovement.straight:
        break;
      case EnemyMovement.sineWave:
        position.x =
            _startX +
            sin(_elapsed * GameBalance.enemySineFrequency) *
                GameBalance.enemySineAmplitude;
        break;
      case EnemyMovement.diagonal:
        position.x += speed * 0.3 * dt;
        break;
    }

    if (position.y > (game.size.y + 60)) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Enemy glow
    final glowPaint = Paint()
      ..color = const Color(0x20FF5252)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    // Enemy body (inverted triangle shape)
    final bodyPath = Path()
      ..moveTo(w / 2, h) // bottom point
      ..lineTo(w, 0)
      ..lineTo(w * 0.7, h * 0.3)
      ..lineTo(w * 0.3, h * 0.3)
      ..lineTo(0, 0)
      ..close();

    final bodyPaint = Paint()..color = const Color(0xFFD32F2F);
    canvas.drawPath(bodyPath, bodyPaint);

    // Core highlight
    final corePath = Path()
      ..moveTo(w / 2, h * 0.85)
      ..lineTo(w * 0.7, h * 0.15)
      ..lineTo(w * 0.3, h * 0.15)
      ..close();
    final corePaint = Paint()..color = const Color(0xFFFF5252);
    canvas.drawPath(corePath, corePaint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayerBullet) {
      other.removeFromParent();
      hp -= other.damage;
      if (hp <= 0) {
        game.addScore(scoreReward);
        removeFromParent();
      }
    }
  }
}
