import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/biome_definition.dart';
import '../generation/sector_generator.dart';

class EndlessEntryScreen extends ConsumerWidget {
  const EndlessEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final endlessProgress = ref.watch(endlessProgressProvider);
    final shipDef = ref.watch(selectedShipDefinitionProvider);
    final nextSector = endlessProgress.highestSector + 1;

    // Preview the next sector
    final preview = SectorGenerator.generate(
      sectorNumber: nextSector,
      seed: 42,
    );
    final biome = BiomeRegistry.getById(preview.biome);

    return Scaffold(
      appBar: AppBar(title: const Text('ENDLESS GALAXY')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Record display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0E1525),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statCol('HIGHEST', '${endlessProgress.highestSector}'),
                    Container(width: 1, height: 30, color: Colors.white12),
                    _statCol('BEST SCORE', '${endlessProgress.bestScore}'),
                    Container(width: 1, height: 30, color: Colors.white12),
                    _statCol('SHIP', shipDef.displayName),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sector preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: biome.bgTint.withValues(alpha: 0.5),
                  border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SECTOR $nextSector',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      biome.id.displayName,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${preview.missionCount} missions',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary.withValues(alpha: 0.6),
                      ),
                    ),
                    if (preview.modifiers.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: preview.modifiers.map((m) {
                          return Chip(
                            label: Text(
                              m.displayName,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: AppTheme.accentColor.withValues(
                              alpha: 0.3,
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(preview),
                  child: Text(
                    nextSector == 1
                        ? 'BEGIN ENDLESS RUN'
                        : 'CONTINUE TO SECTOR $nextSector',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text(
                  'BACK',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCol(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
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
}
