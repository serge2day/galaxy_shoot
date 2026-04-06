import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../projectiles/enemy_bullet.dart';

enum BossFirePattern { spread, burst, radial }

class BossWeapon extends Component with ParentIsA<PositionComponent> {
  double cooldown;
  BossFirePattern firePattern;
  double _timer = 0;

  // Burst state
  int _burstRemaining = 0;
  double _burstTimer = 0;
  static const double _burstInterval = 0.08;

  BossWeapon({
    this.cooldown = GameBalance.bossFireCooldown,
    this.firePattern = BossFirePattern.spread,
  });

  @override
  void update(double dt) {
    super.update(dt);

    // Handle burst firing
    if (_burstRemaining > 0) {
      _burstTimer += dt;
      if (_burstTimer >= _burstInterval) {
        _burstTimer = 0;
        _burstRemaining--;
        _fireSingleBullet(0, GameBalance.bossBulletSpeed);
      }
      return;
    }

    _timer += dt;
    if (_timer >= cooldown) {
      _timer = 0;
      _fire();
    }
  }

  void _fire() {
    switch (firePattern) {
      case BossFirePattern.spread:
        _fireSpread();
        break;
      case BossFirePattern.burst:
        _fireBurst();
        break;
      case BossFirePattern.radial:
        _fireRadial();
        break;
    }
  }

  void _fireSpread() {
    final parentPos = parent.position;
    final parentSize = parent.size;
    final y = parentPos.y + parentSize.y / 2 + 4;

    // Fire 3 bullets spread
    for (int i = -1; i <= 1; i++) {
      final bullet = EnemyBullet(
        startPosition: Vector2(parentPos.x + i * 20.0, y),
        damage: GameBalance.bossBulletDamage,
        speed: GameBalance.bossBulletSpeed,
      );
      parent.parent?.add(bullet);
    }
  }

  void _fireBurst() {
    // Start a rapid 3-shot burst straight down
    _burstRemaining = 2; // first shot fires now, 2 more queued
    _burstTimer = 0;
    _fireSingleBullet(0, GameBalance.bossBulletSpeed);
  }

  void _fireSingleBullet(double xOffset, double speed) {
    final parentPos = parent.position;
    final parentSize = parent.size;
    final y = parentPos.y + parentSize.y / 2 + 4;

    final bullet = EnemyBullet(
      startPosition: Vector2(parentPos.x + xOffset, y),
      damage: GameBalance.bossBulletDamage,
      speed: speed,
    );
    parent.parent?.add(bullet);
  }

  void _fireRadial() {
    final parentPos = parent.position;
    final parentSize = parent.size;
    final y = parentPos.y + parentSize.y / 2 + 4;

    // 5 bullets in a fan pattern
    for (int i = -2; i <= 2; i++) {
      final bullet = EnemyBullet(
        startPosition: Vector2(parentPos.x + i * 16.0, y),
        damage: GameBalance.bossBulletDamage,
        speed: GameBalance.bossBulletSpeed * (0.9 + (2 - i.abs()) * 0.05),
      );
      parent.parent?.add(bullet);
    }
  }
}
