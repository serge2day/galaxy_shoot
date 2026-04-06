enum UpgradeType {
  maxHp,
  fireRate,
  bulletDamage,
  movementSpeed;

  String get displayName {
    switch (this) {
      case UpgradeType.maxHp:
        return 'Max HP';
      case UpgradeType.fireRate:
        return 'Fire Rate';
      case UpgradeType.bulletDamage:
        return 'Bullet Damage';
      case UpgradeType.movementSpeed:
        return 'Movement Speed';
    }
  }

  String get icon {
    switch (this) {
      case UpgradeType.maxHp:
        return '♥';
      case UpgradeType.fireRate:
        return '⚡';
      case UpgradeType.bulletDamage:
        return '💥';
      case UpgradeType.movementSpeed:
        return '→';
    }
  }
}
