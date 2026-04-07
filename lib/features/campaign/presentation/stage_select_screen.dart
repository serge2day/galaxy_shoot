import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../domain/stage_id.dart';

class StageSelectScreen extends ConsumerWidget {
  const StageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Responsive.init(context);
    final progress = ref.watch(campaignProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SELECT STAGE')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: StageId.values.map((stage) {
              final unlocked = progress.isUnlocked(stage);
              final cleared = progress.isCleared(stage);
              final best = progress.bestScoreFor(stage);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _StageCard(
                  stage: stage,
                  unlocked: unlocked,
                  cleared: cleared,
                  bestScore: best,
                  onTap: unlocked
                      ? () => Navigator.of(context).pop(stage)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  final StageId stage;
  final bool unlocked;
  final bool cleared;
  final int bestScore;
  final VoidCallback? onTap;

  const _StageCard({
    required this.stage,
    required this.unlocked,
    required this.cleared,
    required this.bestScore,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stageNum = stage.index + 1;
    Color accent;
    switch (stage) {
      case StageId.stage1:
      case StageId.stage2:
      case StageId.stage3:
        accent = AppTheme.primaryColor;
        break;
      case StageId.stage4:
      case StageId.stage5:
      case StageId.stage6:
        accent = AppTheme.accentColor;
        break;
      case StageId.stage7:
      case StageId.stage8:
      case StageId.stage9:
        accent = AppTheme.dangerColor;
        break;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unlocked ? accent.withValues(alpha: 0.5) : Colors.white12,
          ),
          color: unlocked
              ? accent.withValues(alpha: 0.06)
              : AppTheme.bgCard.withValues(alpha: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: Responsive.w(44),
              height: Responsive.w(44),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? accent.withValues(alpha: 0.15)
                    : Colors.white10,
              ),
              child: Center(
                child: unlocked
                    ? Text(
                        '$stageNum',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accent,
                        ),
                      )
                    : Icon(Icons.lock, color: Colors.white24, size: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        stage.displayName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? accent : AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      if (cleared) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.successColor,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stage.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  if (bestScore > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Best: $bestScore',
                      style: TextStyle(
                        fontSize: 12,
                        color: accent.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (unlocked)
              Icon(Icons.chevron_right, color: accent.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
