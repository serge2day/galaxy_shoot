import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../features/session/domain/run_result.dart';
import '../features/settings/domain/fire_mode.dart';
import 'world/galaxy_world.dart';

enum GameState { playing, paused, gameOver, victory }

class GalaxyGame extends FlameGame with HasCollisionDetection, DragCallbacks {
  final FireMode fireMode;
  final void Function(RunResult result) onGameEnd;

  GameState _state = GameState.playing;
  GameState get state => _state;

  int _score = 0;
  int get score => _score;

  int _hp = 0;
  int get hp => _hp;

  int _lives = 0;
  int get lives => _lives;

  late GalaxyWorld galaxyWorld;

  GalaxyGame({required this.fireMode, required this.onGameEnd});

  @override
  Color backgroundColor() => const Color(0xFF050A18);

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

  void triggerGameOver() {
    if (_state != GameState.playing) return;
    _state = GameState.gameOver;
    pauseEngine();
    onGameEnd(RunResult(score: _score, outcome: RunOutcome.gameOver));
  }

  void triggerVictory() {
    if (_state != GameState.playing) return;
    _state = GameState.victory;
    pauseEngine();
    onGameEnd(RunResult(score: _score, outcome: RunOutcome.victory));
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
      pause();
    }
  }
}
