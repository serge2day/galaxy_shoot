import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../projectiles/enemy_bullet.dart';

class BossWeapon extends Component with ParentIsA<PositionComponent> {
  double cooldown;
  double _timer = 0;

  BossWeapon({this.cooldown = GameBalance.bossFireCooldown});

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= cooldown) {
      _timer = 0;
      _fire();
    }
  }

  void _fire() {
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
}
