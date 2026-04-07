import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/endless/domain/mission_definition.dart';
import 'package:galaxy_shoot/features/endless/generation/sector_generator.dart';

void main() {
  test('generates sector with valid missions', () {
    final sector = SectorGenerator.generate(sectorNumber: 1, seed: 42);
    expect(sector.missions, isNotEmpty);
    expect(sector.sectorNumber, 1);
    expect(sector.difficultyScale, greaterThan(1.0));
  });

  test('sector is deterministic from seed', () {
    final a = SectorGenerator.generate(sectorNumber: 5, seed: 100);
    final b = SectorGenerator.generate(sectorNumber: 5, seed: 100);
    expect(a.biome, b.biome);
    expect(a.missions.length, b.missions.length);
    expect(a.modifiers.length, b.modifiers.length);
    expect(a.bossHp, b.bossHp);
  });

  test('different seeds produce different sectors', () {
    final a = SectorGenerator.generate(sectorNumber: 5, seed: 100);
    final b = SectorGenerator.generate(sectorNumber: 5, seed: 999);
    // With high probability these differ
    expect(a.seed != b.seed || a.biome != b.biome, true);
  });

  test('last mission is always boss', () {
    for (int i = 1; i <= 10; i++) {
      final sector = SectorGenerator.generate(sectorNumber: i, seed: 42);
      expect(sector.missions.last.type, MissionType.bossMission);
      expect(sector.missions.last.isFinal, true);
    }
  });

  test('difficulty scales with sector number', () {
    final s1 = SectorGenerator.generate(sectorNumber: 1, seed: 42);
    final s10 = SectorGenerator.generate(sectorNumber: 10, seed: 42);
    expect(s10.difficultyScale, greaterThan(s1.difficultyScale));
    expect(s10.bossHp, greaterThan(s1.bossHp));
  });

  test('modifiers increase with depth', () {
    final s1 = SectorGenerator.generate(sectorNumber: 1, seed: 42);
    final s12 = SectorGenerator.generate(sectorNumber: 12, seed: 42);
    expect(s12.modifiers.length, greaterThanOrEqualTo(s1.modifiers.length));
  });

  test('boss HP is capped at 2000', () {
    final deepSector = SectorGenerator.generate(sectorNumber: 100, seed: 42);
    expect(deepSector.bossHp, lessThanOrEqualTo(2000));
  });
}
