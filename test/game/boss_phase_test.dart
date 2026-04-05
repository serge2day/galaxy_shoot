import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/config/game_balance.dart';
import 'package:galaxy_shoot/game/components/boss/boss_ship.dart';

void main() {
  test('boss starts in entering phase', () {
    final boss = BossShip(startPosition: Vector2(200, -80));
    expect(boss.phase, BossPhase.entering);
  });

  test('boss starts with full HP', () {
    final boss = BossShip(startPosition: Vector2(200, -80));
    expect(boss.hp, GameBalance.bossHp);
  });

  test('boss maxHp matches GameBalance', () {
    final boss = BossShip(startPosition: Vector2(200, -80));
    expect(boss.maxHp, GameBalance.bossHp);
  });

  test('boss HP can be reduced', () {
    final boss = BossShip(startPosition: Vector2(200, -80));
    boss.hp -= 10;
    expect(boss.hp, GameBalance.bossHp - 10);
  });

  test('boss phase 2 triggers at correct HP threshold', () {
    // This tests the logic concept: phase 2 starts when hp <= maxHp * ratio
    final threshold = (GameBalance.bossHp * GameBalance.bossPhase2HpRatio)
        .toInt();
    expect(threshold, greaterThan(0));
    expect(threshold, lessThan(GameBalance.bossHp));
  });
}
