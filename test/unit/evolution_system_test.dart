import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/game/systems/evolution_system.dart';

void main() {
  late EvolutionSystem evo;

  setUp(() {
    evo = EvolutionSystem();
  });

  test('starts at level 1', () {
    expect(evo.level, 1);
    expect(evo.coresCollected, 0);
  });

  test('collecting cores advances level at threshold', () {
    // Need 5 cores for level 2
    for (int i = 0; i < 4; i++) {
      expect(evo.collectCore(), false);
    }
    expect(evo.level, 1);
    expect(evo.collectCore(), true); // 5th core -> level 2
    expect(evo.level, 2);
  });

  test('evolves through all 5 levels', () {
    // Level thresholds: [0, 5, 12, 22, 35]
    for (int i = 0; i < 5; i++) {
      evo.collectCore();
    } // -> level 2
    expect(evo.level, 2);

    for (int i = 0; i < 7; i++) {
      evo.collectCore();
    } // -> level 3 at 12
    expect(evo.level, 3);

    for (int i = 0; i < 10; i++) {
      evo.collectCore();
    } // -> level 4 at 22
    expect(evo.level, 4);

    for (int i = 0; i < 13; i++) {
      evo.collectCore();
    } // -> level 5 at 35
    expect(evo.level, 5);
  });

  test('fire lanes scale with level', () {
    expect(evo.getFireLanes(), 1);
    for (int i = 0; i < 5; i++) {
      evo.collectCore();
    }
    expect(evo.getFireLanes(), 2); // level 2
    for (int i = 0; i < 7; i++) {
      evo.collectCore();
    }
    expect(evo.getFireLanes(), 2); // level 3
    for (int i = 0; i < 10; i++) {
      evo.collectCore();
    }
    expect(evo.getFireLanes(), 3); // level 4
  });

  test('overdrive charges after max level', () {
    // Get to level 5
    for (int i = 0; i < 35; i++) {
      evo.collectCore();
    }
    expect(evo.level, 5);
    expect(evo.isOverdriveActive, false);

    // Charge overdrive (needs 15 extra cores)
    for (int i = 0; i < 14; i++) {
      evo.collectCore();
    }
    expect(evo.isOverdriveActive, false);
    evo.collectCore(); // 15th extra
    expect(evo.isOverdriveActive, true);
  });

  test('overdrive expires over time', () {
    for (int i = 0; i < 50; i++) {
      evo.collectCore();
    }
    expect(evo.isOverdriveActive, true);

    evo.update(3.0);
    expect(evo.isOverdriveActive, true);

    evo.update(3.0); // total 6s > 5s duration
    expect(evo.isOverdriveActive, false);
  });

  test('peak level tracks highest reached', () {
    for (int i = 0; i < 12; i++) {
      evo.collectCore();
    }
    expect(evo.peakLevel, 3);
    evo.reset();
    expect(evo.peakLevel, 1);
  });

  test('reset clears all state', () {
    for (int i = 0; i < 10; i++) {
      evo.collectCore();
    }
    evo.reset();
    expect(evo.level, 1);
    expect(evo.coresCollected, 0);
    expect(evo.isOverdriveActive, false);
  });

  test('damage multiplier increases with level', () {
    final base = evo.getDamageMultiplier();
    for (int i = 0; i < 5; i++) {
      evo.collectCore();
    }
    expect(evo.getDamageMultiplier(), greaterThan(base));
  });

  test('ship scale increases with level', () {
    expect(evo.getShipScale(), 1.0);
    for (int i = 0; i < 5; i++) {
      evo.collectCore();
    }
    expect(evo.getShipScale(), greaterThan(1.0));
  });
}
