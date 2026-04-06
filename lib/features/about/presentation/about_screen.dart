import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ABOUT')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(
              child: Text(
                'GALAXY SHOOTER',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'v${AppConfig.appVersion}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _section(
              'About the Game',
              'Galaxy Shooter is an offline portrait-mode arcade space shooter. '
                  'Battle through stages, unlock ships, upgrade your fleet, and defeat bosses.',
            ),
            _section(
              'Privacy',
              'This game is fully offline. No personal data is collected, transmitted, or shared. '
                  'All progress is stored locally on your device. '
                  'There is no account system, no cloud sync, and no analytics tracking.',
            ),
            _section(
              'Data Storage',
              'The following data is stored locally on your device:\n'
                  '- Game settings (fire mode, audio/haptics preferences)\n'
                  '- Progression (credits, upgrades, ship unlocks)\n'
                  '- Campaign progress (stage clears, best scores)\n'
                  '- High score\n\n'
                  'You can reset all progress from the Settings screen.',
            ),
            _section(
              'Contact',
              'For support or feedback:\ncontact@example.com',
            ),
            _section(
              'Credits',
              'Built with Flutter and Flame.\n'
                  'All visuals are code-drawn.\n'
                  'No third-party assets used.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
