import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../projectiles/player_bullet.dart';

class PlayerWeapon extends Component with ParentIsA<PositionComponent> {
  double _cooldownTimer = 0;

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
    _cooldownTimer = GameBalance.playerFireCooldown;

    final bullet = PlayerBullet(
      startPosition: Vector2(
        parent.position.x,
        parent.position.y - parent.size.y / 2 - 8,
      ),
    );
    parent.parent?.add(bullet);
  }
}
