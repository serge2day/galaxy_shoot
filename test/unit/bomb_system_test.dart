import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/game/systems/bomb_system.dart';

void main() {
  late BombSystem bomb;

  setUp(() {
    bomb = BombSystem();
  });

  test('starts with no charges', () {
    expect(bomb.charges, 0);
    expect(bomb.hasCharge, false);
  });

  test('addCharge increments', () {
    bomb.addCharge();
    expect(bomb.charges, 1);
    expect(bomb.hasCharge, true);
  });

  test('use returns true and decrements', () {
    bomb.addCharge();
    expect(bomb.use(), true);
    expect(bomb.charges, 0);
  });

  test('use returns false when empty', () {
    expect(bomb.use(), false);
  });

  test('max charges is 3', () {
    for (int i = 0; i < 5; i++) {
      bomb.addCharge();
    }
    expect(bomb.charges, BombSystem.maxCharges);
  });

  test('reset clears charges', () {
    bomb.addCharge();
    bomb.addCharge();
    bomb.reset();
    expect(bomb.charges, 0);
  });
}
