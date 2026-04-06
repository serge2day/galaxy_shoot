import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/game/components/enemies/enemy_type.dart';

void main() {
  test('3 enemy types exist', () {
    expect(EnemyType.values.length, 3);
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

  test('gunship is slower but rewards more', () {
    expect(EnemyType.gunship.baseSpeed, lessThan(EnemyType.drone.baseSpeed));
    expect(
      EnemyType.gunship.scoreReward,
      greaterThan(EnemyType.drone.scoreReward),
    );
  });

  test('gunship is bigger than drone', () {
    expect(EnemyType.gunship.width, greaterThan(EnemyType.drone.width));
    expect(EnemyType.gunship.height, greaterThan(EnemyType.drone.height));
  });
}
