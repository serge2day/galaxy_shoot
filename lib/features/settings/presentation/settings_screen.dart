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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _sectionLabel('Fire Mode'),
            const SizedBox(height: 8),
            _FireModeOption(
              title: 'Auto Fire',
              description: 'Ship fires automatically on cooldown.',
              selected: settings.fireMode == FireMode.auto,
              onTap: () => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(fireMode: FireMode.auto)),
            ),
            const SizedBox(height: 10),
            _FireModeOption(
              title: 'Manual Fire',
              description: 'Use the fire button to shoot.',
              selected: settings.fireMode == FireMode.manual,
              onTap: () => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(fireMode: FireMode.manual)),
            ),
            const SizedBox(height: 28),
            _sectionLabel('Audio & Haptics'),
            const SizedBox(height: 12),
            _ToggleRow(
              label: 'Music',
              value: settings.musicEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(musicEnabled: v)),
            ),
            _ToggleRow(
              label: 'Sound Effects',
              value: settings.sfxEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(sfxEnabled: v)),
            ),
            _ToggleRow(
              label: 'Haptics',
              value: settings.hapticsEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(hapticsEnabled: v)),
            ),
            const SizedBox(height: 28),
            _sectionLabel('Tutorial'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref
                    .read(campaignRepositoryProvider)
                    .setTutorialCompleted();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tutorial will show on next play.'),
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
              child: const Text('REPLAY TUTORIAL'),
            ),
            const SizedBox(height: 28),
            _sectionLabel('Data'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _confirmReset(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dangerColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('RESET ALL PROGRESS'),
            ),
            const SizedBox(height: 8),
            Text(
              'This will erase all credits, upgrades, ship unlocks, and stage progress.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
        letterSpacing: 1,
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.dangerColor.withValues(alpha: 0.4)),
        ),
        title: const Text(
          'Reset Progress?',
          style: TextStyle(color: AppTheme.dangerColor),
        ),
        content: const Text(
          'All credits, upgrades, ship unlocks, and stage progress will be permanently erased.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(resetProgressProvider)();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progress reset.')),
                );
              }
            },
            child: const Text(
              'RESET',
              style: TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _FireModeOption extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _FireModeOption({
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

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
