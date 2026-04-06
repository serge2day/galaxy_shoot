import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../projectiles/enemy_bullet.dart';

class EnemyWeapon extends Component with ParentIsA<PositionComponent> {
  final double cooldown;
  double _timer = 0;

  EnemyWeapon({this.cooldown = GameBalance.enemyFireCooldown});

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
    final bullet = EnemyBullet(
      startPosition: Vector2(
        parent.position.x,
        parent.position.y + parent.size.y / 2 + 4,
      ),
    );
    parent.parent?.add(bullet);
  }
}
