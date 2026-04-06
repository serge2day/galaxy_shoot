import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/game/components/enemies/enemy_type.dart';

void main() {
  test('5 enemy types exist', () {
    expect(EnemyType.values.length, 5);
  });

  test('drone is baseline enemy', () {
    expect(EnemyType.drone.baseHp, 2);
    expect(EnemyType.drone.baseSpeed, 120);
    expect(EnemyType.drone.scoreReward, 100);
  });

  test('interceptor is faster than drone', () {
    expect(
      EnemyType.interceptor.baseSpeed,
      greaterThan(EnemyType.drone.baseSpeed),
    );
  });

  test('gunship is tougher than interceptor', () {
    expect(EnemyType.gunship.baseHp, greaterThan(EnemyType.interceptor.baseHp));
  });

  test('swarmer is small and fast', () {
    expect(EnemyType.swarmer.width, lessThan(EnemyType.drone.width));
    expect(EnemyType.swarmer.baseSpeed, greaterThan(EnemyType.drone.baseSpeed));
    expect(EnemyType.swarmer.baseHp, lessThan(EnemyType.drone.baseHp));
  });

  test('carrier is toughest and slowest', () {
    expect(EnemyType.carrier.baseHp, greaterThan(EnemyType.gunship.baseHp));
    expect(EnemyType.carrier.baseSpeed, lessThan(EnemyType.gunship.baseSpeed));
  });

  test('carrier rewards more than others', () {
    expect(
      EnemyType.carrier.scoreReward,
      greaterThan(EnemyType.gunship.scoreReward),
    );
  });
}
