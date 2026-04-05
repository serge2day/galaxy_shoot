import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../features/settings/domain/fire_mode.dart';
import '../components/background/starfield_component.dart';
import '../components/boss/boss_health_bar.dart';
import '../components/boss/boss_ship.dart';
import '../components/enemies/enemy_ship.dart';
import '../components/player/player_ship.dart';
import '../components/ui/fire_button_component.dart';
import '../components/ui/hud_component.dart';
import '../galaxy_game.dart';
import 'spawn_timeline.dart';

class GalaxyWorld extends Component
    with HasGameReference<GalaxyGame>, DragCallbacks {
  @override
  // ignore: overridden_fields
  final GalaxyGame game;
  late PlayerShip player;
  late HudComponent hud;

  double _levelTimer = 0;
  int _nextWaveIndex = 0;
  bool _bossSpawned = false;
  late List<SpawnEvent> _waves;

  GalaxyWorld({required this.game});

  @override
  Future<void> onLoad() async {
    _waves = SpawnTimeline.buildLevel1();

    // Background
    await add(StarfieldComponent());

    // Player ship
    player = PlayerShip();
    player.position = Vector2(game.size.x / 2, game.size.y * 0.8);
    await add(player);

    // HUD
    hud = HudComponent();
    await add(hud);

    // Fire button for manual mode
    if (game.fireMode == FireMode.manual) {
      await add(FireButtonComponent(player: player));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state != GameState.playing) return;

    _levelTimer += dt;

    // Auto fire
    if (game.fireMode == FireMode.auto) {
      player.weapon.fire();
    }

    // Spawn waves
    while (_nextWaveIndex < _waves.length &&
        _levelTimer >= _waves[_nextWaveIndex].time) {
      _spawnWave(_waves[_nextWaveIndex]);
      _nextWaveIndex++;
    }

    // Spawn boss
    if (!_bossSpawned && _levelTimer >= SpawnTimeline.bossSpawnTime) {
      _spawnBoss();
      _bossSpawned = true;
    }
  }

  void _spawnWave(SpawnEvent event) {
    final gameWidth = game.size.x;
    for (int i = 0; i < event.count; i++) {
      final x = (event.xStart + i * event.xSpacing).clamp(
        30.0,
        gameWidth - 30.0,
      );
      add(
        EnemyShip(
          startPosition: Vector2(x, -40.0 - i * 30.0),
          movement: event.movement,
        ),
      );
    }
  }

  void _spawnBoss() {
    final boss = BossShip(startPosition: Vector2(game.size.x / 2, -80));
    add(boss);
    add(BossHealthBar(boss: boss));
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    player.moveTo(event.localPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    player.moveTo(event.localEndPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    player.stopMoving();
  }
}
