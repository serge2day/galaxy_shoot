/// Authored wave templates used by the wave generator.
/// Each template defines a pattern of enemy spawning.
enum WavePatternId {
  laneAssault,
  staggeredDescent,
  interceptorSweep,
  swarmerFlood,
  heavyAnchor,
  pincerEntry,
  diagonalRain,
  eliteEscort,
  minibossPrelude,
  bossPrelude;

  double get baseThreatCost {
    switch (this) {
      case WavePatternId.laneAssault:
        return 10;
      case WavePatternId.staggeredDescent:
        return 12;
      case WavePatternId.interceptorSweep:
        return 15;
      case WavePatternId.swarmerFlood:
        return 8;
      case WavePatternId.heavyAnchor:
        return 18;
      case WavePatternId.pincerEntry:
        return 14;
      case WavePatternId.diagonalRain:
        return 11;
      case WavePatternId.eliteEscort:
        return 22;
      case WavePatternId.minibossPrelude:
        return 20;
      case WavePatternId.bossPrelude:
        return 25;
    }
  }

  /// Base enemy count for this pattern.
  int get baseCount {
    switch (this) {
      case WavePatternId.laneAssault:
        return 6;
      case WavePatternId.staggeredDescent:
        return 8;
      case WavePatternId.interceptorSweep:
        return 5;
      case WavePatternId.swarmerFlood:
        return 14;
      case WavePatternId.heavyAnchor:
        return 3;
      case WavePatternId.pincerEntry:
        return 6;
      case WavePatternId.diagonalRain:
        return 7;
      case WavePatternId.eliteEscort:
        return 4;
      case WavePatternId.minibossPrelude:
        return 8;
      case WavePatternId.bossPrelude:
        return 10;
    }
  }

  /// Preferred enemy type for this pattern.
  String get preferredEnemy {
    switch (this) {
      case WavePatternId.laneAssault:
        return 'drone';
      case WavePatternId.staggeredDescent:
        return 'drone';
      case WavePatternId.interceptorSweep:
        return 'interceptor';
      case WavePatternId.swarmerFlood:
        return 'swarmer';
      case WavePatternId.heavyAnchor:
        return 'gunship';
      case WavePatternId.pincerEntry:
        return 'interceptor';
      case WavePatternId.diagonalRain:
        return 'drone';
      case WavePatternId.eliteEscort:
        return 'gunship';
      case WavePatternId.minibossPrelude:
        return 'interceptor';
      case WavePatternId.bossPrelude:
        return 'carrier';
    }
  }
}
