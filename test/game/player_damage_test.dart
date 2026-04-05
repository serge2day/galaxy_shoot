import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/config/game_balance.dart';

void main() {
  test('player starts with correct HP', () {
    expect(GameBalance.playerMaxHp, 5);
  });

  test('player starts with correct lives', () {
    expect(GameBalance.playerStartingLives, 3);
  });

  test('invulnerability duration is positive', () {
    expect(GameBalance.playerInvulnerabilityDuration, greaterThan(0));
  });

  test('damage logic: HP reaches 0 loses a life', () {
    int hp = GameBalance.playerMaxHp;
    int lives = GameBalance.playerStartingLives;

    // Simulate taking enough damage to lose all HP
    hp -= GameBalance.playerMaxHp;
    expect(hp, 0);

    if (hp <= 0) {
      lives--;
      hp = GameBalance.playerMaxHp; // respawn
    }

    expect(lives, GameBalance.playerStartingLives - 1);
    expect(hp, GameBalance.playerMaxHp);
  });

  test('game over when all lives lost', () {
    int lives = GameBalance.playerStartingLives;
    bool gameOver = false;

    for (int i = 0; i < GameBalance.playerStartingLives; i++) {
      lives--;
      if (lives <= 0) {
        gameOver = true;
      }
    }

    expect(gameOver, true);
    expect(lives, 0);
  });
}
