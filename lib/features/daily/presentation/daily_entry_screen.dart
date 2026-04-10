import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/endless_game_page.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../endless/domain/biome_definition.dart';
import '../../endless/domain/sector_definition.dart';
import '../../endless/generation/sector_generator.dart';
import '../../progression/domain/difficulty_tier.dart';
import '../domain/daily_result.dart';
import '../domain/daily_schedule.dart';
import '../domain/daily_seed.dart';

class DailyEntryScreen extends ConsumerWidget {
  const DailyEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final result = ref.watch(dailyResultProvider);
    final shipId = DailySchedule.shipIdForDate(now);
    final seed = DailySeed.forDate(now);
    final sector = SectorGenerator.generate(sectorNumber: 1, seed: seed);
    final biome = BiomeRegistry.getById(sector.biome);
    final alreadyPlayed = result.playedOn(now);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        title: Text(
          l.dailyChallenge,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00FF88)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _StatsBar(result: result, l: l),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _TodayCard(
                    l: l,
                    sector: sector,
                    biomeName: l.biome(biome.id.name),
                    shipName: l.shipName(shipId),
                    result: result,
                    alreadyPlayed: alreadyPlayed,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: alreadyPlayed
                      ? null
                      : () => _startDailyRun(
                            context,
                            sector: sector,
                            shipId: shipId,
                          ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF00FF88),
                    foregroundColor: const Color(0xFF001810),
                    disabledBackgroundColor:
                        const Color(0xFF00FF88).withValues(alpha: 0.2),
                    disabledForegroundColor: AppTheme.textSecondary,
                  ),
                  child: Text(
                    alreadyPlayed ? l.dailyAlreadyPlayed : l.dailyStart,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: const BorderSide(color: AppTheme.textSecondary),
                  ),
                  child: Text(l.back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startDailyRun(
    BuildContext context, {
    required SectorDefinition sector,
    required String shipId,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => EndlessGamePage(
          preselectedSector: sector,
          forcedDifficulty: DifficultyTier.veteran,
          forcedShipId: shipId,
          isDaily: true,
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final DailyResult result;
  final AppLocalizations l;

  const _StatsBar({required this.result, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00FF88).withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0x3300FF88),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCell(label: l.dailyStreak, value: '${result.currentStreak}'),
          _StatCell(label: l.dailyBestStreak, value: '${result.bestStreak}'),
          _StatCell(
            label: l.dailyAllTimeBest,
            value: '${result.allTimeBestScore}',
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;

  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF00FF88),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: AppTheme.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  final AppLocalizations l;
  final SectorDefinition sector;
  final String biomeName;
  final String shipName;
  final DailyResult result;
  final bool alreadyPlayed;

  const _TodayCard({
    required this.l,
    required this.sector,
    required this.biomeName,
    required this.shipName,
    required this.result,
    required this.alreadyPlayed,
  });

  @override
  Widget build(BuildContext context) {
    final modifierNames = sector.modifiers
        .map((m) => l.modifier(m.name))
        .toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.bgCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.dailyTodaysChallenge,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Color(0xFF00FF88),
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(l.dailyShip, shipName),
          _infoRow(l.dailyBiome, biomeName),
          _infoRow(
            l.dailyDifficulty,
            l.difficultyVeteran,
          ),
          _infoRow(
            l.dailyMissions,
            '${sector.missionCount}',
          ),
          if (modifierNames.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l.dailyModifiers,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: modifierNames
                  .map(
                    (name) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFFF6D00).withValues(alpha: 0.2),
                        border: Border.all(
                          color:
                              const Color(0xFFFF6D00).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFF6D00),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (alreadyPlayed) ...[
            const Divider(height: 24, color: AppTheme.textSecondary),
            Text(
              l.dailyTodaysResult,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              result.lastCleared
                  ? l.dailyClearedWithScore(result.lastScore)
                  : l.dailyFailedOnMission(
                      result.lastMissionsCleared + 1,
                      result.lastScore,
                    ),
              style: TextStyle(
                fontSize: 14,
                color: result.lastCleared
                    ? AppTheme.successColor
                    : AppTheme.dangerColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
