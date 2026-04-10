import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/difficulty_config.dart';
import '../domain/difficulty_tier.dart';

class DifficultySelectScreen extends StatelessWidget {
  const DifficultySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.selectDifficulty)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                l.chooseChallenge,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              ...DifficultyTier.values.map(
                (tier) => _buildTierCard(context, tier),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard(BuildContext context, DifficultyTier tier) {
    final l = AppLocalizations.of(context);
    final mods = DifficultyConfig.getModifiers(tier);
    final name = switch (tier) {
      DifficultyTier.normal => l.difficultyNormal,
      DifficultyTier.veteran => l.difficultyVeteran,
      DifficultyTier.expert => l.difficultyExpert,
    };
    final desc = switch (tier) {
      DifficultyTier.normal => l.difficultyNormalDesc,
      DifficultyTier.veteran => l.difficultyVeteranDesc,
      DifficultyTier.expert => l.difficultyExpertDesc,
    };
    Color accent;
    switch (tier) {
      case DifficultyTier.normal:
        accent = AppTheme.successColor;
        break;
      case DifficultyTier.veteran:
        accent = AppTheme.primaryColor;
        break;
      case DifficultyTier.expert:
        accent = AppTheme.dangerColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).pop(tier),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.4)),
            color: accent.withValues(alpha: 0.05),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accent,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: accent.withValues(alpha: 0.15),
                ),
                child: Text(
                  'x${mods.rewardMultiplier.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
