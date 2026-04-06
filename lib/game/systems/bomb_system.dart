/// Simple bomb system that clears the screen of enemies and bullets.
class BombSystem {
  static const int maxCharges = 3;

  int _charges = 0;

  bool get hasCharge => _charges > 0;
  int get charges => _charges;

  void addCharge() {
    if (_charges < maxCharges) _charges++;
  }

  /// Attempts to use a bomb charge. Returns true if successful.
  bool use() {
    if (_charges > 0) {
      _charges--;
      return true;
    }
    return false;
  }

  void reset() {
    _charges = 0;
  }
}
