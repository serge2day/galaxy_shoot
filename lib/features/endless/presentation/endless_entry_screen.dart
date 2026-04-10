import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/biome_definition.dart';
import '../domain/sector_definition.dart';
import '../generation/sector_generator.dart';

class EndlessEntryScreen extends ConsumerWidget {
  const EndlessEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Responsive.init(context);
    final endlessProgress = ref.watch(endlessProgressProvider);
    final shipDef = ref.watch(selectedShipDefinitionProvider);
    final nextSector = endlessProgress.highestSector + 1;
    final l = AppLocalizations.of(context);

    // Generate previews for current + upcoming sectors
    final sectors = <SectorDefinition>[];
    for (int i = nextSector; i <= nextSector + 7; i++) {
      sectors.add(SectorGenerator.generate(sectorNumber: i, seed: 42));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.endlessGalaxy)),
      body: SafeArea(
        child: Column(
          children: [
            // Record bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(14),
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
                    _statCol(l.highest, '${endlessProgress.highestSector}'),
                    Container(width: 1, height: 28, color: Colors.white12),
                    _statCol(l.best, '${endlessProgress.bestScore}'),
                    Container(width: 1, height: 28, color: Colors.white12),
                    _statCol(l.ship, l.shipName(shipDef.id)),
                  ],
                ),
              ),
            ),
            // Sector list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sectors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final sector = sectors[index];
                  final isActive = index == 0;
                  final isLocked = index > 0;
                  final biome = BiomeRegistry.getById(sector.biome);

                  return _SectorCard(
                    sector: sector,
                    biome: biome,
                    isActive: isActive,
                    isLocked: isLocked,
                    l: l,
                    onTap: isActive
                        ? () => Navigator.of(context).pop(sector)
                        : null,
                  );
                },
              ),
            ),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(sectors.first),
                      child: Text(
                        nextSector == 1
                            ? l.beginEndlessRun
                            : l.enterSector(nextSector),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text(
                      l.back,
                      style: const TextStyle(color: AppTheme.textSecondary),
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

class _SectorCard extends StatelessWidget {
  final SectorDefinition sector;
  final BiomeDefinition biome;
  final bool isActive;
  final bool isLocked;
  final AppLocalizations l;
  final VoidCallback? onTap;

  const _SectorCard({
    required this.sector,
    required this.biome,
    required this.isActive,
    required this.isLocked,
    required this.l,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? AppTheme.primaryColor
        : isLocked
        ? Colors.white12
        : AppTheme.accentColor.withValues(alpha: 0.4);

    final bgColor = isActive
        ? biome.bgTint.withValues(alpha: 0.6)
        : const Color(0xFF080C18);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isActive ? 2 : 1),
          color: bgColor,
        ),
        child: Row(
          children: [
            // Sector number circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppTheme.primaryColor.withValues(alpha: 0.15)
                    : Colors.white10,
                border: Border.all(
                  color: isActive
                      ? AppTheme.primaryColor.withValues(alpha: 0.5)
                      : Colors.white12,
                ),
              ),
              child: Center(
                child: isLocked
                    ? Icon(
                        Icons.lock,
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.2),
                      )
                    : Text(
                        '${sector.sectorNumber}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppTheme.primaryColor
                              : Colors.white38,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            // Sector info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.sectorNumber(sector.sectorNumber),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: isActive
                          ? AppTheme.primaryColor
                          : isLocked
                          ? Colors.white24
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.biome(biome.id.name),
                    style: TextStyle(
                      fontSize: 13,
                      color: isLocked
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppTheme.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 4),
                    Text(
                      l.missionCount(sector.missionCount),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Modifiers / locked indicator
            if (isActive && sector.modifiers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: sector.modifiers
                    .take(2)
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          l.modifier(m.name),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.accentColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            else if (isLocked)
              Text(
                l.locked,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              )
            else if (isActive)
              const Icon(
                Icons.play_arrow,
                color: AppTheme.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
