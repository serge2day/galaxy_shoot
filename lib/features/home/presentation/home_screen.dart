import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/routes.dart';
import '../../../app/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestScore = ref.watch(bestScoreProvider);
    final wallet = ref.watch(walletProvider);
    final shipDef = ref.watch(selectedShipDefinitionProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppTheme.bgDark),
            ),
          ),
          // Bottom gradient for UI
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
          // UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  // Stats bar
                  _StatsBar(
                    bestScore: bestScore,
                    credits: wallet.credits,
                    shipName: shipDef.displayName,
                  ),
                  const SizedBox(height: 20),
                  // Campaign button
                  _StyledButton(
                    label: 'CAMPAIGN',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFF00E5FF)],
                    ),
                    borderColor: const Color(0xFF00E5FF),
                    textColor: const Color(0xFF001820),
                    onTap: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.game),
                  ),
                  const SizedBox(height: 10),
                  // Endless Galaxy Mode button
                  _StyledButton(
                    label: 'ENDLESS GALAXY',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A0040), Color(0xFF3A1880)],
                    ),
                    borderColor: const Color(0xFFFF6D00),
                    textColor: const Color(0xFFFF6D00),
                    onTap: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(AppRoutes.endless),
                  ),
                  const SizedBox(height: 10),
                  // HANGAR button
                  _StyledButton(
                    label: 'HANGAR',
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1040), Color(0xFF2A1860)],
                    ),
                    borderColor: const Color(0xFF7C4DFF),
                    textColor: const Color(0xFF00E5FF),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.hangar),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.settings),
                          icon: const Icon(
                            Icons.settings,
                            color: AppTheme.primaryColor,
                            size: 18,
                          ),
                          label: const Text(
                            'SETTINGS',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              letterSpacing: 1,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.about),
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppTheme.textSecondary,
                            size: 18,
                          ),
                          label: const Text(
                            'ABOUT',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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

  const _StatsBar({
    required this.bestScore,
    required this.credits,
    required this.shipName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
        ),
        color: const Color(0xA0000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _col('BEST', '$bestScore'),
          Container(width: 1, height: 32, color: Colors.white12),
          _col('CREDITS', '$credits'),
          Container(width: 1, height: 32, color: Colors.white12),
          _col('ACTIVE SHIP', shipName),
        ],
      ),
    );
  }

  Widget _col(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
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
