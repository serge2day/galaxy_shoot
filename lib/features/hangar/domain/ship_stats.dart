class ShipStats {
  final int maxHp;
  final int startingLives;
  final double speed;
  final double fireCooldown;
  final int bulletDamage;
  final double shipWidth;
  final double shipHeight;
  final double hitboxScale;

  const ShipStats({
    required this.maxHp,
    required this.startingLives,
    required this.speed,
    required this.fireCooldown,
    required this.bulletDamage,
    required this.shipWidth,
    required this.shipHeight,
    this.hitboxScale = 0.7,
  });

  ShipStats copyWith({
    int? maxHp,
    int? startingLives,
    double? speed,
    double? fireCooldown,
    int? bulletDamage,
    double? shipWidth,
    double? shipHeight,
    double? hitboxScale,
  }) {
    return ShipStats(
      maxHp: maxHp ?? this.maxHp,
      startingLives: startingLives ?? this.startingLives,
      speed: speed ?? this.speed,
      fireCooldown: fireCooldown ?? this.fireCooldown,
      bulletDamage: bulletDamage ?? this.bulletDamage,
      shipWidth: shipWidth ?? this.shipWidth,
      shipHeight: shipHeight ?? this.shipHeight,
      hitboxScale: hitboxScale ?? this.hitboxScale,
    );
  }
}
