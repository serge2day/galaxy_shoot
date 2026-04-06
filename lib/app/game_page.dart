import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/campaign/domain/stage_id.dart';
import '../features/campaign/presentation/stage_select_screen.dart';
import '../features/hangar/domain/resolved_ship_stats.dart';
import '../features/hangar/domain/ship_definition.dart';
import '../features/progression/domain/difficulty_tier.dart';
import '../features/progression/domain/reward_calculator.dart';
import '../features/progression/presentation/difficulty_select_screen.dart';
import '../features/progression/presentation/run_summary_screen.dart';
import '../features/session/domain/run_result.dart';
import '../features/tutorial/presentation/tutorial_screen.dart';
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
  StageId _stageId = StageId.stage1;
  bool _ready = false;
  bool _showPause = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFlow();
    });
  }

  Future<void> _startFlow() async {
    // Check tutorial
    final campaignRepo = ref.read(campaignRepositoryProvider);
    final tutorialDone = await campaignRepo.isTutorialCompleted();
    if (!tutorialDone && mounted) {
      await Navigator.of(
        context,
      ).push<bool>(MaterialPageRoute(builder: (_) => const TutorialScreen()));
      await campaignRepo.setTutorialCompleted();
    }

    if (!mounted) return;

    // Stage select
    final stage = await Navigator.of(context).push<StageId>(
      MaterialPageRoute(builder: (_) => const StageSelectScreen()),
    );
    if (stage == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }
    _stageId = stage;

    if (!mounted) return;

    // Difficulty select
    final tier = await Navigator.of(context).push<DifficultyTier>(
      MaterialPageRoute(builder: (_) => const DifficultySelectScreen()),
    );
    if (tier == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }
    _difficulty = tier;
    setState(() => _ready = true);
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
      stageId: _stageId,
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

    // Update stage progress
    ref
        .read(campaignProgressProvider.notifier)
        .updateBestScore(_stageId.name, claimedResult.score);

    if (claimedResult.outcome == RunOutcome.victory) {
      ref
          .read(campaignProgressProvider.notifier)
          .clearStage(_stageId.name, claimedResult.score);
    }

    final shipDef = ShipCatalog.getById(_game!.shipId);

    setState(() {
      _summaryData = RunSummaryData(
        result: claimedResult,
        rewards: rewards,
        difficulty: _difficulty,
        shipName: shipDef.displayName,
        previousBestScore: previousBest,
        newBestScore: ref.read(bestScoreProvider),
        stageId: _stageId,
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

  void _goNextStage() {
    final next = _stageId.next;
    if (next != null) {
      _stageId = next;
      _initGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: SizedBox.shrink(),
      );
    }

    if (_summaryData != null) {
      final canNextStage =
          _summaryData!.result.outcome == RunOutcome.victory &&
          _stageId.next != null;
      return RunSummaryScreen(
        data: _summaryData!,
        onPlayAgain: _restart,
        onHome: _goHome,
        onHangar: _goHangar,
        onNextStage: canNextStage ? _goNextStage : null,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_game != null) GameWidget(game: _game!),
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
