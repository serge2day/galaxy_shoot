import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/endless/domain/biome_definition.dart';
import '../features/endless/domain/modifier_definition.dart';
import '../features/endless/domain/sector_definition.dart';
import '../features/endless/generation/sector_generator.dart';
import '../features/endless/generation/wave_generator.dart';
import '../features/endless/presentation/endless_entry_screen.dart';
import '../features/hangar/domain/resolved_ship_stats.dart';
import '../features/progression/domain/difficulty_tier.dart';
import '../features/progression/domain/reward_calculator.dart';
import '../features/progression/presentation/difficulty_select_screen.dart';
import '../features/campaign/domain/stage_id.dart';
import '../features/session/domain/run_result.dart';
import '../game/galaxy_game.dart';
import '../game/world/stages/stage_definition.dart';
import 'providers.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class EndlessGamePage extends ConsumerStatefulWidget {
  const EndlessGamePage({super.key});

  @override
  ConsumerState<EndlessGamePage> createState() => _EndlessGamePageState();
}

class _EndlessGamePageState extends ConsumerState<EndlessGamePage> {
  GalaxyGame? _game;
  SectorDefinition? _currentSector;
  int _currentMissionIndex = 0;
  int _totalScore = 0;
  int _totalKills = 0;
  bool _ready = false;
  bool _showPause = false;
  bool _showSectorResults = false;
  int _countdown = 0;
  DifficultyTier _difficulty = DifficultyTier.normal;

  bool _showMissionTransition = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startFlow());
  }

  Future<void> _startFlow() async {
    if (!mounted) return;

    // Endless entry screen
    final sector = await Navigator.of(context).push<SectorDefinition>(
      MaterialPageRoute(builder: (_) => const EndlessEntryScreen()),
    );
    if (sector == null || !mounted) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }

    // Difficulty select
    final tier = await Navigator.of(context).push<DifficultyTier>(
      MaterialPageRoute(builder: (_) => const DifficultySelectScreen()),
    );
    if (tier == null || !mounted) {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      return;
    }

    _difficulty = tier;
    _currentSector = sector;
    _currentMissionIndex = 0;
    _totalScore = 0;
    _totalKills = 0;
    setState(() => _ready = true);
    _startMission();
  }

  void _startMission() {
    if (_currentSector == null) return;
    final sector = _currentSector!;
    final mission = sector.missions[_currentMissionIndex];
    final biome = BiomeRegistry.getById(sector.biome);
    final modEffect = ModifierRegistry.combined(sector.modifiers);

    // Generate waves for this mission
    final rng = Random(sector.seed + _currentMissionIndex * 31);
    final waves = WaveGenerator.generate(
      rng: rng,
      mission: mission,
      biome: biome,
      difficultyScale: sector.difficultyScale,
      modifiers: modEffect,
    );

    // Convert to stage definition for GalaxyGame
    final waveTemplates = waves
        .map(
          (w) => WaveTemplate(
            time: w.time,
            count: w.count,
            enemyType: w.enemyType,
            movement: w.movement,
            isElite: w.isElite,
          ),
        )
        .toList();

    final lastWaveTime = waveTemplates.isEmpty ? 30.0 : waveTemplates.last.time;
    // Give enough buffer after last wave for enemies to clear
    final bossTime = lastWaveTime + 12.0;

    final stageDef = StageDefinition(
      id: _campaignStageForBiome(sector.biome),
      waves: waveTemplates,
      bossSpawnTime: bossTime,
      bossConfig: BossConfig(
        baseHp: mission.type.hasBoss ? sector.bossHp : 1,
        baseCooldown: sector.bossFireRate,
        phase2HpRatio: 0.6,
        phase3HpRatio: 0.25,
        speed: 80 + sector.sectorNumber * 3,
        width: 90,
        height: 78,
      ),
      bgTint: biome.bgTint,
      starSpeed: biome.starSpeed,
      hasBoss: mission.type.hasBoss,
    );

    final fireMode = ref.read(gameSettingsProvider).fireMode;
    final shipDef = ref.read(selectedShipDefinitionProvider);
    final upgrades = ref.read(upgradeStateProvider);
    final stats = ResolvedShipStats.resolve(ship: shipDef, upgrades: upgrades);

    _game = GalaxyGame(
      fireMode: fireMode,
      shipStats: stats,
      difficulty: _difficulty,
      shipId: shipDef.id,
      stageId: stageDef.id,
      onGameEnd: _onMissionEnd,
      onPauseRequested: _handlePause,
    );

    // Override the stage def
    _game!.stageDef = stageDef;

    setState(() {
      _showPause = false;
      _showSectorResults = false;
    });
  }

  void _handlePause() {
    if (_game?.state == GameState.playing) {
      _game?.pause();
      setState(() => _showPause = true);
    }
  }

  void _onMissionEnd(RunResult result) {
    final claimed = _game?.claimResult();
    if (claimed == null) return;

    _totalScore += claimed.score;
    _totalKills += claimed.enemyKills;

    if (claimed.outcome == RunOutcome.gameOver) {
      // Run ended
      _showEndlessResults(false);
      return;
    }

    // Mission cleared
    _currentMissionIndex++;
    if (_currentMissionIndex >= _currentSector!.missions.length) {
      _onSectorCleared();
    } else {
      // Show mission transition before starting next
      _showMissionTransitionScreen();
    }
  }

  Future<void> _showMissionTransitionScreen() async {
    setState(() => _showMissionTransition = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _showMissionTransition = false);
    _startMission();
  }

  void _onSectorCleared() {
    final sector = _currentSector!;
    final rewards = RewardCalculator.calculate(
      enemyKills: _totalKills,
      bossDefeated: true,
      isVictory: true,
      difficulty: _difficulty,
    );
    ref.read(walletProvider.notifier).addCredits(rewards.totalCredits);
    ref.read(bestScoreProvider.notifier).submit(_totalScore);
    ref
        .read(endlessProgressProvider.notifier)
        .recordSectorCleared(
          sector.sectorNumber,
          _totalScore,
          ref.read(selectedShipProvider),
        );
    _showEndlessResults(true);
  }

  void _showEndlessResults(bool sectorCleared) {
    if (!sectorCleared) {
      // Grant partial rewards
      final rewards = RewardCalculator.calculate(
        enemyKills: _totalKills,
        bossDefeated: false,
        isVictory: false,
        difficulty: _difficulty,
      );
      ref.read(walletProvider.notifier).addCredits(rewards.totalCredits);
      ref.read(bestScoreProvider.notifier).submit(_totalScore);
    }
    setState(() => _showSectorResults = true);
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _continueNextSector() {
    final nextSector = SectorGenerator.generate(
      sectorNumber: (_currentSector?.sectorNumber ?? 0) + 1,
      seed: 42,
    );
    _currentSector = nextSector;
    _currentMissionIndex = 0;
    _totalScore = 0;
    _totalKills = 0;
    setState(() => _showSectorResults = false);
    _startMission();
  }

  Future<void> _startResumeCountdown() async {
    setState(() {
      _showPause = false;
      _countdown = 3;
    });
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (!mounted) return;
    setState(() => _countdown = 0);
    _game?.resume();
  }

  static StageId _campaignStageForBiome(BiomeId biome) {
    switch (biome) {
      case BiomeId.frontierVoid:
        return StageId.stage1;
      case BiomeId.nebulaDrift:
        return StageId.stage4;
      case BiomeId.wardenBelt:
        return StageId.stage5;
      case BiomeId.crimsonRift:
        return StageId.stage7;
      case BiomeId.ruinOrbit:
        return StageId.stage8;
      case BiomeId.coreAbyss:
        return StageId.stage9;
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

    if (_showSectorResults) {
      return _buildResultsScreen();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handlePause();
      },
      child: Scaffold(
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
                onPressed: _handlePause,
              ),
            ),
            // Sector/mission info
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0x80000000),
                ),
                child: Text(
                  'S${_currentSector?.sectorNumber ?? 0} M${_currentMissionIndex + 1}/${_currentSector?.missionCount ?? 0}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_showMissionTransition) _buildMissionTransition(),
            if (_showPause) _buildPauseOverlay(),
            if (_countdown > 0) _buildCountdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final sectorCleared =
        _currentMissionIndex >= (_currentSector?.missionCount ?? 0);
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  sectorCleared ? 'SECTOR CLEARED!' : 'RUN OVER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: sectorCleared
                        ? AppTheme.successColor
                        : AppTheme.dangerColor,
                  ),
                ),
                const SizedBox(height: 20),
                _resultRow('Sector', '${_currentSector?.sectorNumber ?? 0}'),
                _resultRow(
                  'Missions Cleared',
                  '$_currentMissionIndex / ${_currentSector?.missionCount ?? 0}',
                ),
                _resultRow('Score', '$_totalScore'),
                _resultRow('Enemies Defeated', '$_totalKills'),
                const SizedBox(height: 28),
                if (sectorCleared)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continueNextSector,
                      child: const Text('NEXT SECTOR'),
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _goHome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.textSecondary),
                    ),
                    child: const Text('HOME'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTransition() {
    final nextMission = _currentSector?.missions[_currentMissionIndex];
    return Container(
      color: const Color(0xDD000000),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'MISSION ${_currentMissionIndex + 1}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryColor,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            if (nextMission != null)
              Text(
                nextMission.type.displayName.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  letterSpacing: 2,
                ),
              ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
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
                    onPressed: _startResumeCountdown,
                    child: const Text('RESUME'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _goHome,
                  child: const Text(
                    'HOME',
                    style: TextStyle(color: AppTheme.dangerColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Text(
          '$_countdown',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: AppTheme.primaryColor.withValues(alpha: 0.9),
            shadows: [
              Shadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
                blurRadius: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
