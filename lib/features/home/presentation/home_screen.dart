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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildTitle(),
                const SizedBox(height: 16),
                _buildSubtitle(),
                const Spacer(),
                _buildInfoRow(bestScore, wallet.credits, shipDef.displayName),
                const SizedBox(height: 32),
                _buildNewGameButton(context),
                const SizedBox(height: 12),
                _buildHangarButton(context),
                const SizedBox(height: 12),
                _buildSettingsButton(context),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppTheme.primaryColor, AppTheme.accentColor],
      ).createShader(bounds),
      child: const Text(
        'GALAXY\nSHOOTER',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
          height: 1.1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'PHASE 2',
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 6,
        color: AppTheme.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildInfoRow(int bestScore, int credits, String shipName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
        color: AppTheme.bgCard.withValues(alpha: 0.5),
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

  Widget _buildNewGameButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(AppRoutes.game),
        child: const Text('NEW GAME'),
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

  Widget _buildSettingsButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
      icon: const Icon(Icons.settings, color: AppTheme.textSecondary),
      label: const Text(
        'SETTINGS',
        style: TextStyle(color: AppTheme.textSecondary, letterSpacing: 1.5),
      ),
    );
  }
}
