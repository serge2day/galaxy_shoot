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
                _buildBestScore(bestScore),
                const SizedBox(height: 40),
                _buildNewGameButton(context),
                const SizedBox(height: 16),
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
      'PHASE 1',
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 6,
        color: AppTheme.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildBestScore(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
        color: AppTheme.bgCard.withValues(alpha: 0.5),
      ),
      child: Column(
        children: [
          Text(
            'BEST SCORE',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 2,
              color: AppTheme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
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
