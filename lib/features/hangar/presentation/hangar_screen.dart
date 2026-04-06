import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../progression/domain/upgrade_definition.dart';
import '../../progression/domain/upgrade_type.dart';
import '../domain/ship_definition.dart';
import 'ship_card.dart';
import 'upgrade_panel.dart';

class HangarScreen extends ConsumerWidget {
  const HangarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedShipsProvider);
    final selectedId = ref.watch(selectedShipProvider);
    final wallet = ref.watch(walletProvider);
    final upgradeState = ref.watch(upgradeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HANGAR'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${wallet.credits} CR',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'SHIPS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...ShipCatalog.ships.map((ship) {
              final isUnlocked = unlockedIds.contains(ship.id);
              final isSelected = ship.id == selectedId;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ShipCard(
                  ship: ship,
                  isUnlocked: isUnlocked,
                  isSelected: isSelected,
                  credits: wallet.credits,
                  onSelect: () =>
                      ref.read(selectedShipProvider.notifier).select(ship.id),
                  onUnlock: () async {
                    final success = await ref
                        .read(walletProvider.notifier)
                        .spend(ship.unlockCost);
                    if (success) {
                      await ref
                          .read(unlockedShipsProvider.notifier)
                          .unlock(ship.id);
                    }
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
            UpgradePanel(
              upgradeState: upgradeState,
              credits: wallet.credits,
              onPurchase: (UpgradeType type) async {
                final def = UpgradeConfig.getDefinition(type);
                final currentLevel = upgradeState.levelOf(type);
                if (currentLevel >= def.maxLevel) return;
                final cost = def.costForLevel(currentLevel + 1);
                final success = await ref
                    .read(walletProvider.notifier)
                    .spend(cost);
                if (success) {
                  final newState = upgradeState.withUpgrade(
                    type,
                    currentLevel + 1,
                  );
                  await ref
                      .read(upgradeStateProvider.notifier)
                      .applyUpgrade(newState);
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
