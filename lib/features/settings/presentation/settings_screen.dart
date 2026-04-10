import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/fire_mode.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gameSettingsProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _sectionLabel(l.fireModeSection),
            const SizedBox(height: 8),
            _FireModeOption(
              title: l.autoFire,
              description: l.autoFireDesc,
              selected: settings.fireMode == FireMode.auto,
              onTap: () => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(fireMode: FireMode.auto)),
            ),
            const SizedBox(height: 10),
            _FireModeOption(
              title: l.manualFire,
              description: l.manualFireDesc,
              selected: settings.fireMode == FireMode.manual,
              onTap: () => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(fireMode: FireMode.manual)),
            ),
            const SizedBox(height: 28),
            _sectionLabel(l.audioHapticsSection),
            const SizedBox(height: 12),
            _ToggleRow(
              label: l.music,
              value: settings.musicEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(musicEnabled: v)),
            ),
            if (settings.musicEnabled)
              _VolumeSlider(
                label: l.musicVolume,
                value: settings.musicVolume,
                onChanged: (v) => ref
                    .read(gameSettingsProvider.notifier)
                    .update(settings.copyWith(musicVolume: v)),
              ),
            _ToggleRow(
              label: l.soundEffects,
              value: settings.sfxEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(sfxEnabled: v)),
            ),
            if (settings.sfxEnabled)
              _VolumeSlider(
                label: l.sfxVolume,
                value: settings.sfxVolume,
                onChanged: (v) => ref
                    .read(gameSettingsProvider.notifier)
                    .update(settings.copyWith(sfxVolume: v)),
              ),
            _ToggleRow(
              label: l.haptics,
              value: settings.hapticsEnabled,
              onChanged: (v) => ref
                  .read(gameSettingsProvider.notifier)
                  .update(settings.copyWith(hapticsEnabled: v)),
            ),
            const SizedBox(height: 28),
            _sectionLabel(l.tutorialSection),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref.read(campaignRepositoryProvider).resetTutorial();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.tutorialWillShow),
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
              child: Text(l.replayTutorial),
            ),
            const SizedBox(height: 28),
            _sectionLabel(l.dataSection),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _confirmReset(context, ref, l),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dangerColor,
                foregroundColor: Colors.white,
              ),
              child: Text(l.resetAllProgress),
            ),
            const SizedBox(height: 8),
            Text(
              l.resetWarning,
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

  void _confirmReset(BuildContext context, WidgetRef ref, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.dangerColor.withValues(alpha: 0.4)),
        ),
        title: Text(
          l.resetDialogTitle,
          style: const TextStyle(color: AppTheme.dangerColor),
        ),
        content: Text(
          l.resetDialogBody,
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l.cancel,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(resetProgressProvider)();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.progressReset)),
                );
              }
            },
            child: Text(
              l.reset,
              style: const TextStyle(color: AppTheme.dangerColor),
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

class _VolumeSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppTheme.primaryColor,
                inactiveTrackColor: AppTheme.primaryColor.withValues(
                  alpha: 0.2,
                ),
                thumbColor: AppTheme.primaryColor,
                overlayColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: value,
                min: 0.0,
                max: 1.0,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
