import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../projectiles/player_bullet.dart';

class PlayerWeapon extends Component with ParentIsA<PositionComponent> {
  final double cooldown;
  final int damage;
  double _cooldownTimer = 0;

  PlayerWeapon({
    this.cooldown = GameBalance.playerFireCooldown,
    this.damage = GameBalance.playerBulletDamage,
  });

  bool get canFire => _cooldownTimer <= 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (_cooldownTimer > 0) {
      _cooldownTimer -= dt;
    }
  }

  void fire() {
    if (!canFire) return;
    _cooldownTimer = cooldown;

    final bullet = PlayerBullet(
      startPosition: Vector2(
        parent.position.x,
        parent.position.y - parent.size.y / 2 - 8,
      ),
      damage: damage,
    );
    parent.parent?.add(bullet);
  }
}
