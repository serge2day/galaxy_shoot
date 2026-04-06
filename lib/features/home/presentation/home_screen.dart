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
          // Background image (falls back to dark color if missing)
          Image.asset(
            'assets/images/home_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppTheme.bgDark),
          ),
          // Dark gradient overlay for readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xAA000000),
                  Color(0xDD000000),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // UI content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(flex: 3),
                    _buildInfoRow(
                        bestScore, wallet.credits, shipDef.displayName),
                    const SizedBox(height: 28),
                    _buildPlayButton(context),
                    const SizedBox(height: 12),
                    _buildHangarButton(context),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRoutes.settings),
                            icon: const Icon(Icons.settings,
                                color: AppTheme.textSecondary, size: 18),
                            label: const Text(
                              'SETTINGS',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                letterSpacing: 1,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRoutes.about),
                            icon: const Icon(Icons.info_outline,
                                color: AppTheme.textSecondary, size: 18),
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
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(int bestScore, int credits, String shipName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
        color: const Color(0x60000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _infoColumn('BEST', '$bestScore'),
          Container(width: 1, height: 30, color: Colors.white12),
          _infoColumn('CREDITS', '$credits'),
          Container(width: 1, height: 30, color: Colors.white12),
          _infoColumn('SHIP', shipName),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.5,
            color: AppTheme.textSecondary.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(AppRoutes.game),
        child: const Text('PLAY'),
      ),
    );
  }

  Widget _buildHangarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.hangar),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.accentColor,
          side: const BorderSide(color: AppTheme.accentColor),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        child: const Text('HANGAR'),
      ),
    );
  }
}
