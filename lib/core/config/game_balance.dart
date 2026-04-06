class GameBalance {
  const GameBalance._();

  // Player
  static const int playerMaxHp = 4;
  static const int playerStartingLives = 3;
  static const double playerSpeed = 500.0;
  static const double playerInvulnerabilityDuration = 0.6;
  static const double playerShipWidth = 40.0;
  static const double playerShipHeight = 48.0;

  // Player weapon
  static const double playerFireCooldown = 0.18;
  static const double playerBulletSpeed = 600.0;
  static const int playerBulletDamage = 1;
  static const double playerBulletWidth = 4.0;
  static const double playerBulletHeight = 14.0;

  // Enemy
  static const int enemyHp = 2;
  static const double enemySpeed = 120.0;
  static const double enemyFireCooldown = 1.2;
  static const double enemyBulletSpeed = 300.0;
  static const int enemyBulletDamage = 2;
  static const int enemyScoreReward = 100;
  static const double enemyShipWidth = 36.0;
  static const double enemyShipHeight = 36.0;
  static const double enemySineAmplitude = 40.0;
  static const double enemySineFrequency = 2.0;

  // Boss
  static const int bossHp = 40;
  static const double bossSpeed = 80.0;
  static const double bossFireCooldown = 0.6;
  static const double bossBulletSpeed = 240.0;
  static const int bossBulletDamage = 2;
  static const int bossScoreReward = 2000;
  static const double bossWidth = 80.0;
  static const double bossHeight = 70.0;
  static const double bossPhase2HpRatio = 0.5;
  static const double bossPhase2FireCooldown = 0.35;
  static const double bossPhase2Speed = 140.0;

  // Level
  static const double levelDurationBeforeBoss = 55.0;
  static const double waveInterval = 4.0;
  static const int enemiesPerWave = 4;

  // Starfield
  static const int starfieldLayerCount = 3;
  static const int starsPerLayer = 40;
}
