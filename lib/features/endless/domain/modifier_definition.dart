enum ModifierId {
  aggressiveSwarm,
  heavyArmor,
  stormFront,
  volatileCore,
  elitePatrol,
  weaponSurge;

  String get displayName {
    switch (this) {
      case ModifierId.aggressiveSwarm:
        return 'Aggressive Swarm';
      case ModifierId.heavyArmor:
        return 'Heavy Armor';
      case ModifierId.stormFront:
        return 'Storm Front';
      case ModifierId.volatileCore:
        return 'Volatile Core';
      case ModifierId.elitePatrol:
        return 'Elite Patrol';
      case ModifierId.weaponSurge:
        return 'Weapon Surge';
    }
  }

  String get description {
    switch (this) {
      case ModifierId.aggressiveSwarm:
        return '+50% enemy count, more small enemies';
      case ModifierId.heavyArmor:
        return '+40% enemy HP';
      case ModifierId.stormFront:
        return '+60% hazard density';
      case ModifierId.volatileCore:
        return '+30% rewards, +25% enemy damage';
      case ModifierId.elitePatrol:
        return '2x elite encounter chance';
      case ModifierId.weaponSurge:
        return '+50% evolution core drops';
    }
  }
}

class ModifierEffect {
  final double enemyCountScale;
  final double enemyHpScale;
  final double hazardScale;
  final double rewardScale;
  final double eliteScale;
  final double dropRateScale;

  const ModifierEffect({
    this.enemyCountScale = 1.0,
    this.enemyHpScale = 1.0,
    this.hazardScale = 1.0,
    this.rewardScale = 1.0,
    this.eliteScale = 1.0,
    this.dropRateScale = 1.0,
  });
}

class ModifierRegistry {
  const ModifierRegistry._();

  static const Map<ModifierId, ModifierEffect> effects = {
    ModifierId.aggressiveSwarm: ModifierEffect(enemyCountScale: 1.5),
    ModifierId.heavyArmor: ModifierEffect(enemyHpScale: 1.4),
    ModifierId.stormFront: ModifierEffect(hazardScale: 1.6),
    ModifierId.volatileCore: ModifierEffect(
      rewardScale: 1.3,
      enemyHpScale: 1.15,
    ),
    ModifierId.elitePatrol: ModifierEffect(eliteScale: 2.0),
    ModifierId.weaponSurge: ModifierEffect(dropRateScale: 1.5),
  };

  static ModifierEffect combined(List<ModifierId> mods) {
    var countScale = 1.0;
    var hpScale = 1.0;
    var hazardScale = 1.0;
    var rewardScale = 1.0;
    var eliteScale = 1.0;
    var dropScale = 1.0;

    for (final mod in mods) {
      final e = effects[mod]!;
      countScale *= e.enemyCountScale;
      hpScale *= e.enemyHpScale;
      hazardScale *= e.hazardScale;
      rewardScale *= e.rewardScale;
      eliteScale *= e.eliteScale;
      dropScale *= e.dropRateScale;
    }

    return ModifierEffect(
      enemyCountScale: countScale,
      enemyHpScale: hpScale,
      hazardScale: hazardScale,
      rewardScale: rewardScale,
      eliteScale: eliteScale,
      dropRateScale: dropScale,
    );
  }
}
