import 'dart:math';

import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';
import '../../galaxy_game.dart';
import '../../systems/evolution_system.dart';
import '../effects/muzzle_flash.dart';
import '../projectiles/player_bullet.dart';

class PlayerWeapon extends Component with ParentIsA<PositionComponent> {
  final double baseCooldown;
  final int baseDamage;
  double _cooldownTimer = 0;

  PlayerWeapon({
    double cooldown = GameBalance.playerFireCooldown,
    int damage = GameBalance.playerBulletDamage,
  }) : baseCooldown = cooldown,
       baseDamage = damage;

  bool get canFire => _cooldownTimer <= 0;

  EvolutionSystem? get _evolution {
    final game = findGame();
    if (game is GalaxyGame) return game.evolution;
    return null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_cooldownTimer > 0) {
      _cooldownTimer -= dt;
    }
  }

  void fire() {
    if (!canFire) return;

    final evo = _evolution;
    final lanes = evo?.getFireLanes() ?? 1;
    final dmgMul = evo?.getDamageMultiplier() ?? 1.0;
    final rateMultiplier = evo?.fireRateMultiplier ?? 1.0;

    _cooldownTimer = baseCooldown * rateMultiplier;
    final effectiveDamage = (baseDamage * dmgMul).ceil();

    final px = parent.position.x;
    final py = parent.position.y - parent.size.y / 2 - 8;

    switch (lanes) {
      case 1:
        _spawnBullet(px, py, effectiveDamage);
        break;
      case 2:
        _spawnBullet(px - 8, py, effectiveDamage);
        _spawnBullet(px + 8, py, effectiveDamage);
        break;
      case 3:
        _spawnBullet(px - 14, py, effectiveDamage);
        _spawnBullet(px, py - 4, effectiveDamage);
        _spawnBullet(px + 14, py, effectiveDamage);
        break;
      default:
        // 4+ lanes (overdrive)
        final spread = min(lanes, 5);
        final halfSpread = (spread - 1) / 2;
        for (int i = 0; i < spread; i++) {
          final offset = (i - halfSpread) * 10.0;
          _spawnBullet(px + offset, py, effectiveDamage);
        }
        break;
    }

    // Muzzle flash
    parent.parent?.add(MuzzleFlash(position: Vector2(px, py)));
  }

  void _spawnBullet(double x, double y, int damage) {
    parent.parent?.add(
      PlayerBullet(startPosition: Vector2(x, y), damage: damage),
    );
  }
}
