import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/hangar/domain/resolved_ship_stats.dart';
import '../features/hangar/domain/ship_definition.dart';
import '../features/progression/domain/difficulty_tier.dart';
import '../features/progression/domain/reward_calculator.dart';
import '../features/progression/presentation/difficulty_select_screen.dart';
import '../features/progression/presentation/run_summary_screen.dart';
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
  RunSummaryData? _summaryData;
  DifficultyTier _difficulty = DifficultyTier.normal;
  bool _difficultySelected = false;
  bool _showPause = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectDifficulty();
    });
  }

  Future<void> _selectDifficulty() async {
    final tier = await Navigator.of(context).push<DifficultyTier>(
      MaterialPageRoute(builder: (_) => const DifficultySelectScreen()),
    );
    if (tier == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }
    setState(() {
      _difficulty = tier;
      _difficultySelected = true;
    });
    _initGame();
  }

  void _initGame() {
    final fireMode = ref.read(gameSettingsProvider).fireMode;
    final shipDef = ref.read(selectedShipDefinitionProvider);
    final upgrades = ref.read(upgradeStateProvider);
    final stats = ResolvedShipStats.resolve(ship: shipDef, upgrades: upgrades);

    _game = GalaxyGame(
      fireMode: fireMode,
      shipStats: stats,
      difficulty: _difficulty,
      shipId: shipDef.id,
      onGameEnd: _onGameEnd,
      onPauseRequested: _handlePauseRequest,
    );
    setState(() {
      _summaryData = null;
      _showPause = false;
    });
  }

  void _handlePauseRequest() {
    if (_game?.state == GameState.playing) {
      _game?.pause();
      setState(() => _showPause = true);
    }
  }

  void _onGameEnd(RunResult result) {
    final claimedResult = _game?.claimResult();
    if (claimedResult == null) return;

    final previousBest = ref.read(bestScoreProvider);
    ref.read(bestScoreProvider.notifier).submit(claimedResult.score);

    final rewards = RewardCalculator.calculate(
      enemyKills: claimedResult.enemyKills,
      bossDefeated: claimedResult.bossDefeated,
      isVictory: claimedResult.outcome == RunOutcome.victory,
      difficulty: _difficulty,
    );

    ref.read(walletProvider.notifier).addCredits(rewards.totalCredits);

    final shipDef = ShipCatalog.getById(_game!.shipId);

    setState(() {
      _summaryData = RunSummaryData(
        result: claimedResult,
        rewards: rewards,
        difficulty: _difficulty,
        shipName: shipDef.displayName,
        previousBestScore: previousBest,
        newBestScore: ref.read(bestScoreProvider),
      );
    });
  }

  void _restart() {
    setState(() {
      _summaryData = null;
      _initGame();
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _goHangar() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.hangar);
  }

  @override
  Widget build(BuildContext context) {
    if (!_difficultySelected) {
      return const Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: SizedBox.shrink(),
      );
    }

    if (_summaryData != null) {
      return RunSummaryScreen(
        data: _summaryData!,
        onPlayAgain: _restart,
        onHome: _goHome,
        onHangar: _goHangar,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_game != null) GameWidget(game: _game!),
          // Pause button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(
                Icons.pause,
                color: AppTheme.textSecondary,
                size: 28,
              ),
              onPressed: _handlePauseRequest,
            ),
          ),
          // Pause overlay
          if (_showPause) _buildPauseOverlay(),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _showPause = false);
                      _game?.resume();
                    },
                    child: const Text('RESUME'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _showPause = false);
                      _restart();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('RESTART'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _goHome,
                  child: const Text(
                    'HOME',
                    style: TextStyle(
                      color: AppTheme.dangerColor,
                      letterSpacing: 1,
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
