import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/fire_mode.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gameSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fire Mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose how your ship fires during gameplay.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              _FireModeOption(
                mode: FireMode.auto,
                title: 'Auto Fire',
                description: 'Ship fires automatically on cooldown.',
                selected: settings.fireMode == FireMode.auto,
                onTap: () => ref
                    .read(gameSettingsProvider.notifier)
                    .update(settings.copyWith(fireMode: FireMode.auto)),
              ),
              const SizedBox(height: 12),
              _FireModeOption(
                mode: FireMode.manual,
                title: 'Manual Fire',
                description: 'Use the fire button to shoot.',
                selected: settings.fireMode == FireMode.manual,
                onTap: () => ref
                    .read(gameSettingsProvider.notifier)
                    .update(settings.copyWith(fireMode: FireMode.manual)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FireModeOption extends StatelessWidget {
  final FireMode mode;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _FireModeOption({
    required this.mode,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : AppTheme.bgCard,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
