import 'dart:math';

/// Manages in-run ship evolution. Plain Dart class used by GalaxyGame.
///
/// As the player collects evolution cores, their ship levels up through
/// 5 tiers gaining additional fire lanes and damage. After max level,
/// extra cores charge an overdrive mode.
class EvolutionSystem {
  static const int maxLevel = 5;
  static const List<int> thresholds = [0, 5, 12, 22, 35];
  static const double overdriveChargeNeeded = 15;
  static const double overdriveDuration = 5.0;

  int _coresCollected = 0;
  int _level = 1;
  double _overdriveCharge = 0;
  bool _overdriveActive = false;
  double _overdriveTimer = 0;
  int _peakLevel = 1;

  int get coresCollected => _coresCollected;
  int get level => _level;
  double get overdriveCharge => _overdriveCharge;
  bool get isOverdriveActive => _overdriveActive;
  double get overdriveTimer => _overdriveTimer;
  int get peakLevel => _peakLevel;

  /// Progress toward overdrive activation (0.0 to 1.0).
  double get overdriveProgress {
    if (_overdriveActive) return 1.0;
    if (_level < maxLevel) return 0.0;
    return (_overdriveCharge / overdriveChargeNeeded).clamp(0.0, 1.0);
  }

  /// Returns the number of cores needed to reach the next level,
  /// or -1 if already at max level.
  int get coresToNextLevel {
    if (_level >= maxLevel) return -1;
    return thresholds[_level] - _coresCollected;
  }

  /// Collects a core. Returns true if the player leveled up.
  bool collectCore() {
    _coresCollected++;

    if (_level < maxLevel) {
      // Check for level up
      if (_level < maxLevel && _coresCollected >= thresholds[_level]) {
        _level++;
        _peakLevel = max(_peakLevel, _level);
        return true;
      }
    } else {
      // Already at max level - charge overdrive
      _overdriveCharge++;
      if (_overdriveCharge >= overdriveChargeNeeded && !_overdriveActive) {
        _overdriveActive = true;
        _overdriveTimer = overdriveDuration;
        _overdriveCharge = 0;
      }
    }
    return false;
  }

  /// Update overdrive timer. Call every frame.
  void update(double dt) {
    if (_overdriveActive) {
      _overdriveTimer -= dt;
      if (_overdriveTimer <= 0) {
        _overdriveActive = false;
        _overdriveTimer = 0;
      }
    }
  }

  /// Returns the number of fire lanes for the current effective level.
  /// Level 1: 1 lane, Level 2-3: 2 lanes, Level 4-5: 3 lanes.
  /// Overdrive: 5 lanes.
  int getFireLanes() {
    if (_overdriveActive) return 5;
    switch (_level) {
      case 1:
        return 1;
      case 2:
      case 3:
        return 2;
      case 4:
      case 5:
        return 3;
      default:
        return 1;
    }
  }

  /// Returns the damage multiplier for the current level.
  double getDamageMultiplier() {
    if (_overdriveActive) return 3.0;
    return 1.0 + (_level - 1) * 0.25; // 1.0, 1.25, 1.5, 1.75, 2.0
  }

  /// Returns the fire rate multiplier (lower = faster firing).
  /// Decreases as level increases. Overdrive fires very fast.
  double get fireRateMultiplier {
    if (_overdriveActive) return 0.4;
    return 1.0 - (_level - 1) * 0.08; // 1.0, 0.92, 0.84, 0.76, 0.68
  }

  /// Drops one evolution level as a penalty (e.g. on death).
  /// Cannot drop below level 1.
  void dropLevel() {
    if (_level > 1) {
      _level--;
      // Reset cores to the threshold of the new level
      _coresCollected = thresholds[_level - 1];
    }
  }

  /// Returns the visual scale factor for the ship.
  double getShipScale() {
    if (_overdriveActive) return 1.5;
    return 1.0 + (_level - 1) * 0.1; // 1.0, 1.1, 1.2, 1.3, 1.4
  }

  /// Resets the system for a new run.
  void reset() {
    _coresCollected = 0;
    _level = 1;
    _overdriveCharge = 0;
    _overdriveActive = false;
    _overdriveTimer = 0;
    _peakLevel = 1;
  }
}
