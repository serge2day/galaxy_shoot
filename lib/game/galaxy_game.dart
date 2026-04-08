import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/services/game_audio.dart';
import '../features/campaign/domain/stage_id.dart';
import '../features/hangar/domain/ship_stats.dart';
import '../features/progression/domain/difficulty_config.dart';
import '../features/progression/domain/difficulty_tier.dart';
import '../features/session/domain/run_result.dart';
import '../features/settings/domain/fire_mode.dart';
import 'systems/bomb_system.dart';
import 'systems/evolution_system.dart';
import 'world/galaxy_world.dart';
import 'world/stages/stage_definition.dart';
import 'world/stages/stage_registry.dart';

enum GameState { playing, paused, gameOver, victory }

class GalaxyGame extends FlameGame with HasCollisionDetection, DragCallbacks {
  final FireMode fireMode;
  final ShipStats shipStats;
  final DifficultyTier difficulty;
  final DifficultyModifiers difficultyModifiers;
  final String shipId;
  final StageId stageId;
  late StageDefinition stageDef;
  final void Function(RunResult result) onGameEnd;
  final VoidCallback? onPauseRequested;

  GameState _state = GameState.playing;
  GameState get state => _state;

  int _score = 0;
  int get score => _score;

  int _hp = 0;
  int get hp => _hp;

  int _lives = 0;
  int get lives => _lives;

  int _enemyKills = 0;
  int get enemyKills => _enemyKills;

  bool _bossDefeated = false;
  bool get bossDefeated => _bossDefeated;

  bool _rewardsClaimed = false;

  final EvolutionSystem evolution = EvolutionSystem();
  final BombSystem bomb = BombSystem();

  // Convenience getters
  int get weaponLevel => evolution.level;

  late GalaxyWorld galaxyWorld;

  GalaxyGame({
    required this.fireMode,
    required this.shipStats,
    required this.difficulty,
    required this.shipId,
    required this.stageId,
    required this.onGameEnd,
    this.onPauseRequested,
  }) : difficultyModifiers = DifficultyConfig.getModifiers(difficulty),
       stageDef = StageRegistry.get(stageId);

  @override
  Color backgroundColor() => stageDef.bgTint;

  @override
  Future<void> onLoad() async {
    galaxyWorld = GalaxyWorld(game: this);
    await add(galaxyWorld);
  }

  @override
  void update(double dt) {
    super.update(dt);
    evolution.update(dt);
  }

  void setHp(int value) {
    _hp = value;
  }

  void setLives(int value) {
    _lives = value;
  }

  void addScore(int points) {
    _score += points;
  }

  void recordEnemyKill() {
    _enemyKills++;
  }

  void recordBossDefeat() {
    _bossDefeated = true;
  }

  /// Collect an evolution core. Returns true if level changed.
  bool collectEvolutionCore() {
    return evolution.collectCore();
  }

  /// Use a bomb if available. Returns true if bomb was used.
  bool useBomb() {
    return bomb.use();
  }

  RunResult? claimResult() {
    if (_rewardsClaimed) return null;
    _rewardsClaimed = true;
    return RunResult(
      score: _score,
      outcome: _state == GameState.victory
          ? RunOutcome.victory
          : RunOutcome.gameOver,
      enemyKills: _enemyKills,
      bossDefeated: _bossDefeated,
      peakEvolutionLevel: evolution.peakLevel,
    );
  }

  void triggerGameOver() {
    if (_state != GameState.playing) return;
    _state = GameState.gameOver;
    GameAudio.gameOver();
    GameAudio.stopMusic();
    pauseEngine();
    onGameEnd(
      RunResult(
        score: _score,
        outcome: RunOutcome.gameOver,
        enemyKills: _enemyKills,
        bossDefeated: _bossDefeated,
        peakEvolutionLevel: evolution.peakLevel,
      ),
    );
  }

  void triggerVictory() {
    if (_state != GameState.playing) return;
    _state = GameState.victory;
    GameAudio.victory();
    GameAudio.stopMusic();
    pauseEngine();
    onGameEnd(
      RunResult(
        score: _score,
        outcome: RunOutcome.victory,
        enemyKills: _enemyKills,
        bossDefeated: _bossDefeated,
        peakEvolutionLevel: evolution.peakLevel,
      ),
    );
  }

  void pause() {
    if (_state == GameState.playing) {
      _state = GameState.paused;
      pauseEngine();
    }
  }

  void resume() {
    if (_state == GameState.paused) {
      _state = GameState.playing;
      resumeEngine();
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_state == GameState.playing) {
      galaxyWorld.player.moveTo(event.canvasPosition);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_state == GameState.playing) {
      galaxyWorld.player.moveTo(event.canvasEndPosition);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    galaxyWorld.player.stopMoving();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_state == GameState.playing) {
        onPauseRequested?.call();
      }
    }
  }
}
