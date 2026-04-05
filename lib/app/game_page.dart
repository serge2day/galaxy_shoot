import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/session/domain/run_result.dart';
import '../game/galaxy_game.dart';
import 'providers.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  GalaxyGame? _game;
  RunResult? _result;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final fireMode = ref.read(gameSettingsProvider).fireMode;
    _game = GalaxyGame(fireMode: fireMode, onGameEnd: _onGameEnd);
  }

  void _onGameEnd(RunResult result) {
    ref.read(bestScoreProvider.notifier).submit(result.score);
    setState(() {
      _result = result;
    });
  }

  void _restart() {
    setState(() {
      _result = null;
      _initGame();
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_game != null) GameWidget(game: _game!),
          // Pause button
          if (_result == null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.pause,
                  color: AppTheme.textSecondary,
                  size: 28,
                ),
                onPressed: () {
                  if (_game?.state == GameState.playing) {
                    _game?.pause();
                    _showPauseDialog();
                  }
                },
              ),
            ),
          // Game Over / Victory overlay
          if (_result != null) _buildEndOverlay(),
        ],
      ),
    );
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
        ),
        title: const Text(
          'PAUSED',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.primaryColor, letterSpacing: 2),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _game?.resume();
            },
            child: const Text(
              'RESUME',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _goHome();
            },
            child: const Text(
              'QUIT',
              style: TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndOverlay() {
    final isVictory = _result!.outcome == RunOutcome.victory;
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isVictory
                    ? AppTheme.successColor.withValues(alpha: 0.5)
                    : AppTheme.dangerColor.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (isVictory ? AppTheme.successColor : AppTheme.dangerColor)
                          .withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isVictory ? 'VICTORY' : 'GAME OVER',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: isVictory
                        ? AppTheme.successColor
                        : AppTheme.dangerColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'SCORE',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_result!.score}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _restart,
                    child: const Text('PLAY AGAIN'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _goHome,
                  child: const Text(
                    'HOME',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
