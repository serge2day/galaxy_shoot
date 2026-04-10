import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../features/campaign/domain/stage_id.dart';
import '../../../l10n/app_localizations.dart';
import '../../session/domain/run_result.dart';
import '../domain/difficulty_tier.dart';
import '../domain/reward_breakdown.dart';

class RunSummaryData {
  final RunResult result;
  final RewardBreakdown rewards;
  final DifficultyTier difficulty;
  final String shipId;
  final int previousBestScore;
  final int newBestScore;
  final StageId stageId;

  const RunSummaryData({
    required this.result,
    required this.rewards,
    required this.difficulty,
    required this.shipId,
    required this.previousBestScore,
    required this.newBestScore,
    required this.stageId,
  });

  bool get isNewBest => result.score > previousBestScore;
}

class RunSummaryScreen extends StatelessWidget {
  final RunSummaryData data;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;
  final VoidCallback onHangar;
  final VoidCallback? onNextStage;

  const RunSummaryScreen({
    super.key,
    required this.data,
    required this.onPlayAgain,
    required this.onHome,
    required this.onHangar,
    this.onNextStage,
  });

  @override
  Widget build(BuildContext context) {
    final isVictory = data.result.outcome == RunOutcome.victory;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isVictory ? l.victory : l.gameOver,
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
                _buildInfoCard(context, l),
                const SizedBox(height: 16),
                _buildRewardsCard(l),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPlayAgain,
                    child: Text(l.playAgain),
                  ),
                ),
                if (onNextStage != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onNextStage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.successColor,
                        side: const BorderSide(color: AppTheme.successColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l.nextStage),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onHangar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.accentColor,
                          side: const BorderSide(color: AppTheme.accentColor),
                        ),
                        child: Text(l.hangar),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: onHome,
                        child: Text(
                          l.home,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations l) {
    final stageNum = data.stageId.index + 1;
    final difficultyName = switch (data.difficulty) {
      DifficultyTier.normal => l.difficultyNormal,
      DifficultyTier.veteran => l.difficultyVeteran,
      DifficultyTier.expert => l.difficultyExpert,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.bgCard,
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _infoRow(l.scoreLabel, '${data.result.score}'),
          if (data.isNewBest)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l.newBest,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor.withValues(alpha: 0.8),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          const Divider(height: 20, color: Colors.white10),
          _infoRow(l.shipLabel, l.shipName(data.shipId)),
          const SizedBox(height: 6),
          _infoRow(l.stageLabel, l.stageName(stageNum)),
          const SizedBox(height: 6),
          _infoRow(l.difficultyLabel, difficultyName),
          const SizedBox(height: 6),
          _infoRow(l.enemiesDefeated, '${data.result.enemyKills}'),
          const SizedBox(height: 6),
          _infoRow(l.peakEvolution, l.evolutionLevel(data.result.peakEvolutionLevel)),
        ],
      ),
    );
  }

  Widget _buildRewardsCard(AppLocalizations l) {
    final r = data.rewards;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.bgCard,
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            l.creditsEarned,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '+${r.totalCredits}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _rewardLine(l.enemyKills, r.enemyKillCredits),
          if (r.bossDefeatCredits > 0)
            _rewardLine(l.bossDefeat, r.bossDefeatCredits),
          if (r.victoryBonusCredits > 0)
            _rewardLine(l.victoryBonus, r.victoryBonusCredits),
          if (r.difficultyMultiplier != 1.0)
            _rewardLine(
              l.difficultyBonus,
              0,
              suffix: 'x${r.difficultyMultiplier.toStringAsFixed(1)}',
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _rewardLine(String label, int amount, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
          ),
          Text(
            suffix ?? '+$amount',
            style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
