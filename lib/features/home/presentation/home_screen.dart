import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/game_audio.dart';
import '../../../core/utils/responsive.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Responsive.init(context);
    GameAudio.playMenuMusic();
    final bestScore = ref.watch(bestScoreProvider);
    final wallet = ref.watch(walletProvider);
    final shipDef = ref.watch(selectedShipDefinitionProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppTheme.bgDark),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xBB000000),
                    Color(0xF0000000),
                  ],
                  stops: [0.0, 0.45, 0.58, 0.78, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(24)),
              child: Column(
                children: [
                  const Spacer(),
                  _StatsBar(
                    bestScore: bestScore,
                    credits: wallet.credits,
                    shipName: l.shipName(shipDef.id),
                    labelBest: l.best,
                    labelCredits: l.credits,
                    labelShip: l.ship,
                  ),
                  SizedBox(height: Responsive.h(16)),
                  _StyledButton(
                    label: l.campaign,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFF00E5FF)],
                    ),
                    borderColor: const Color(0xFF00E5FF),
                    textColor: const Color(0xFF001820),
                    onTap: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.game),
                  ),
                  SizedBox(height: Responsive.h(8)),
                  _StyledButton(
                    label: l.endlessGalaxy,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A0040), Color(0xFF3A1880)],
                    ),
                    borderColor: const Color(0xFFFF6D00),
                    textColor: const Color(0xFFFF6D00),
                    onTap: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.endless),
                  ),
                  SizedBox(height: Responsive.h(8)),
                  _StyledButton(
                    label: l.dailyChallenge,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF002818), Color(0xFF005030)],
                    ),
                    borderColor: const Color(0xFF00FF88),
                    textColor: const Color(0xFF00FF88),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.daily),
                  ),
                  SizedBox(height: Responsive.h(8)),
                  _StyledButton(
                    label: l.hangar,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1040), Color(0xFF2A1860)],
                    ),
                    borderColor: const Color(0xFF7C4DFF),
                    textColor: const Color(0xFF00E5FF),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.hangar),
                  ),
                  SizedBox(height: Responsive.h(8)),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.settings),
                          icon: Icon(
                            Icons.settings,
                            color: AppTheme.primaryColor,
                            size: Responsive.sp(16),
                          ),
                          label: Text(
                            l.settings,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              letterSpacing: 1,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.about),
                          icon: Icon(
                            Icons.info_outline,
                            color: AppTheme.textSecondary,
                            size: Responsive.sp(16),
                          ),
                          label: Text(
                            l.about,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final int bestScore;
  final int credits;
  final String shipName;
  final String labelBest;
  final String labelCredits;
  final String labelShip;

  const _StatsBar({
    required this.bestScore,
    required this.credits,
    required this.shipName,
    required this.labelBest,
    required this.labelCredits,
    required this.labelShip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(14),
        vertical: Responsive.h(10),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.w(10)),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
        ),
        color: const Color(0xA0000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _col(labelBest, '$bestScore'),
          Container(width: 1, height: Responsive.h(28), color: Colors.white12),
          _col(labelCredits, '$credits'),
          Container(width: 1, height: Responsive.h(28), color: Colors.white12),
          _col(labelShip, shipName),
        ],
      ),
    );
  }

  Widget _col(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.sp(9),
            letterSpacing: 1.2,
            color: const Color(0xFF9E9E9E),
          ),
        ),
        SizedBox(height: Responsive.h(3)),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.sp(14),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00E5FF),
          ),
        ),
      ],
    );
  }
}

class _StyledButton extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _StyledButton({
    required this.label,
    required this.gradient,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: Responsive.h(14)),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(Responsive.w(10)),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: Responsive.sp(17),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
