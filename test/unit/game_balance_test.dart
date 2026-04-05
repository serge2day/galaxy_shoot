import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/config/game_balance.dart';

void main() {
  test('player max HP is positive', () {
    expect(GameBalance.playerMaxHp, greaterThan(0));
  });

  test('player starting lives is positive', () {
    expect(GameBalance.playerStartingLives, greaterThan(0));
  });

  test('boss HP is greater than enemy HP', () {
    expect(GameBalance.bossHp, greaterThan(GameBalance.enemyHp));
  });

  test('boss phase 2 HP ratio is between 0 and 1', () {
    expect(GameBalance.bossPhase2HpRatio, greaterThan(0));
    expect(GameBalance.bossPhase2HpRatio, lessThan(1));
  });

  test('boss phase 2 is more aggressive', () {
    expect(
      GameBalance.bossPhase2FireCooldown,
      lessThan(GameBalance.bossFireCooldown),
    );
    expect(GameBalance.bossPhase2Speed, greaterThan(GameBalance.bossSpeed));
  });

  test('player fire cooldown is within expected range', () {
    expect(GameBalance.playerFireCooldown, greaterThanOrEqualTo(0.1));
    expect(GameBalance.playerFireCooldown, lessThanOrEqualTo(0.3));
  });
}
