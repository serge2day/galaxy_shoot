import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../features/campaign/domain/stage_id.dart';
import '../features/hangar/domain/ship_stats.dart';
import '../features/progression/domain/difficulty_config.dart';
import '../features/progression/domain/difficulty_tier.dart';
import '../features/session/domain/run_result.dart';
import '../features/settings/domain/fire_mode.dart';
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
  final StageDefinition stageDef;
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

  int _weaponLevel = 1;
  int get weaponLevel => _weaponLevel;

  bool _rewardsClaimed = false;

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

  void boostWeapon() {
    if (_weaponLevel < 3) {
      _weaponLevel++;
    }
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
    );
  }

  void triggerGameOver() {
    if (_state != GameState.playing) return;
    _state = GameState.gameOver;
    pauseEngine();
    onGameEnd(
      RunResult(
        score: _score,
        outcome: RunOutcome.gameOver,
        enemyKills: _enemyKills,
        bossDefeated: _bossDefeated,
      ),
    );
  }

  void triggerVictory() {
    if (_state != GameState.playing) return;
    _state = GameState.victory;
    pauseEngine();
    onGameEnd(
      RunResult(
        score: _score,
        outcome: RunOutcome.victory,
        enemyKills: _enemyKills,
        bossDefeated: _bossDefeated,
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
