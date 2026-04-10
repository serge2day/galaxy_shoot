import 'dart:math';

import 'package:flame/components.dart';

import '../../features/hangar/domain/ship_definition.dart';
import '../../features/settings/domain/fire_mode.dart';
import '../../core/services/game_audio.dart';
import '../components/background/space_background.dart';
import '../components/background/starfield_component.dart';
import '../components/boss/boss_health_bar.dart';
import '../components/boss/boss_ship.dart';
import '../components/enemies/enemy_ship.dart';
import '../components/enemies/enemy_type.dart';
import '../components/obstacles/asteroid.dart';
import '../components/obstacles/satellite_debris.dart';
import '../components/obstacles/space_debris.dart';
import '../components/obstacles/space_mine.dart';
import '../components/player/player_ship.dart';
import '../components/ui/fire_button_component.dart';
import '../components/ui/hud_component.dart';
import '../galaxy_game.dart';
import 'formation_spawner.dart';
import 'stages/stage_definition.dart';

class GalaxyWorld extends Component with HasGameReference<GalaxyGame> {
  @override
  // ignore: overridden_fields
  final GalaxyGame game;
  late PlayerShip player;
  late HudComponent hud;

  double _levelTimer = 0;
  int _nextWaveIndex = 0;
  bool _bossSpawned = false;
  bool _victoryTriggered = false;
  late List<_ResolvedWave> _waves;
  final Random _rng = Random();

  double _asteroidTimer = 0;
  double _debrisTimer = 0;
  double _mineTimer = 0;
  double _satelliteTimer = 0;

  GalaxyWorld({required this.game});

  @override
  Future<void> onLoad() async {
    final stageDef = game.stageDef;

    _waves = stageDef.waves.map((template) {
      return _ResolvedWave(
        time: template.time,
        count: template.count,
        enemyType: template.enemyType,
        movement: template.movement,
        isElite: template.isElite,
      );
    }).toList()..sort((a, b) => a.time.compareTo(b.time));

    // Rich space background (nebulae, planets, stars)
    await add(SpaceBackground(stageIndex: game.stageId.index));

    // Starfield on top
    await add(
      StarfieldComponent(
        tint: stageDef.bgTint,
        speedMultiplier: stageDef.starSpeed,
      ),
    );

    final shipDef = ShipCatalog.getById(game.shipId);
    player = PlayerShip(
      stats: game.shipStats,
      visualStyle: shipDef.visualStyle,
      shipId: shipDef.id,
    );
    player.position = Vector2(game.size.x / 2, game.size.y * 0.8);
    await add(player);

    hud = HudComponent();
    await add(hud);

    // Start battle music
    GameAudio.playBattleMusic();

    if (game.fireMode == FireMode.manual) {
      await add(FireButtonComponent(player: player));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    _levelTimer += dt;

    if (game.fireMode == FireMode.auto) {
      player.weapon.fire();
    }

    while (_nextWaveIndex < _waves.length &&
        _levelTimer >= _waves[_nextWaveIndex].time) {
      _spawnWave(_waves[_nextWaveIndex]);
      _nextWaveIndex++;
    }

    // Boss missions: spawn boss at scheduled time.
    if (game.stageDef.hasBoss) {
      if (!_bossSpawned && _levelTimer >= game.stageDef.bossSpawnTime) {
        _spawnBoss();
        _bossSpawned = true;
      }
    } else {
      // Non-boss missions: end as soon as every wave has spawned and
      // no enemies remain on screen, instead of waiting for a fixed timer.
      if (_nextWaveIndex >= _waves.length && !_victoryTriggered) {
        final enemiesLeft = children.whereType<EnemyShip>().isNotEmpty;
        if (!enemiesLeft) {
          _victoryTriggered = true;
          game.triggerVictory();
        }
      }
    }

    _spawnObstacles(dt);
  }

  void _spawnWave(_ResolvedWave wave) {
    final gameWidth = game.size.x;
    // Use formation spawner for organized enemy patterns
    final enemies = FormationSpawner.spawn(
      count: wave.count,
      enemyType: wave.enemyType,
      movement: wave.movement,
      gameWidth: gameWidth,
      isElite: wave.isElite,
    );
    for (final enemy in enemies) {
      add(enemy);
    }
  }

  void _spawnObstacles(double dt) {
    final gameWidth = game.size.x;
    final stageIdx = game.stageId.index;

    // Asteroids - varied sizes
    final asteroidInterval = stageIdx < 3
        ? 6.0
        : stageIdx < 6
        ? 4.0
        : 2.5;
    _asteroidTimer += dt;
    if (_asteroidTimer >= asteroidInterval) {
      _asteroidTimer = 0;
      final x = 30.0 + _rng.nextDouble() * (gameWidth - 60);
      final sz = 18.0 + _rng.nextDouble() * 30.0 + stageIdx * 2;
      add(
        Asteroid(
          startPosition: Vector2(x, -40),
          speed: 45 + _rng.nextDouble() * 50 + stageIdx * 5,
          hp: 2 + stageIdx ~/ 3,
          asteroidSize: sz,
        ),
      );
    }

    // Space debris - cosmetic
    _debrisTimer += dt;
    if (_debrisTimer >= 1.5) {
      _debrisTimer = 0;
      add(
        SpaceDebris(
          startPosition: Vector2(_rng.nextDouble() * gameWidth, -15),
          debrisSize: 5 + _rng.nextDouble() * 12,
        ),
      );
    }

    // Space mines - from stage 3+
    if (stageIdx >= 2) {
      final mineInterval = stageIdx < 6 ? 10.0 : 6.0;
      _mineTimer += dt;
      if (_mineTimer >= mineInterval) {
        _mineTimer = 0;
        add(
          SpaceMine(
            startPosition: Vector2(
              40 + _rng.nextDouble() * (gameWidth - 80),
              -30,
            ),
            speed: 35 + _rng.nextDouble() * 25,
          ),
        );
      }
    }

    // Satellite debris - from stage 5+
    if (stageIdx >= 4) {
      final satInterval = stageIdx < 7 ? 14.0 : 8.0;
      _satelliteTimer += dt;
      if (_satelliteTimer >= satInterval) {
        _satelliteTimer = 0;
        add(
          SatelliteDebris(
            startPosition: Vector2(
              40 + _rng.nextDouble() * (gameWidth - 80),
              -50,
            ),
            speed: 30 + _rng.nextDouble() * 20,
            hp: 4 + stageIdx ~/ 3,
          ),
        );
      }
    }
  }

  void _spawnBoss() {
    final boss = BossShip(
      startPosition: Vector2(game.size.x / 2, -80),
      config: game.stageDef.bossConfig,
      stageIndex: game.stageId.index,
    );
    add(boss);
    add(BossHealthBar(boss: boss));
  }
}

class _ResolvedWave {
  final double time;
  final int count;
  final EnemyType enemyType;
  final EnemyMovementType movement;
  final bool isElite;

  _ResolvedWave({
    required this.time,
    required this.count,
    required this.enemyType,
    required this.movement,
    this.isElite = false,
  });
}
