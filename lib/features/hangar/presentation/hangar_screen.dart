import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../progression/domain/upgrade_definition.dart';
import '../domain/ship_definition.dart';

class HangarScreen extends ConsumerWidget {
  const HangarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedShipsProvider);
    final selectedId = ref.watch(selectedShipProvider);
    final wallet = ref.watch(walletProvider);
    final upgradeState = ref.watch(upgradeStateProvider);
    final selectedShip = ShipCatalog.getById(selectedId);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed('/');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.bgDark,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        title: const Text(
          'HANGAR',
          style: TextStyle(fontSize: 22, letterSpacing: 2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${wallet.credits} CR',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Large hero ship display
          _HeroShipDisplay(ship: selectedShip),
          const SizedBox(height: 14),
          const Text(
            'SHIP SELECTION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Compact horizontal ship cards
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ShipCatalog.ships.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final ship = ShipCatalog.ships[index];
                final isUnlocked = unlockedIds.contains(ship.id);
                final isSelected = ship.id == selectedId;
                return _ShipCard(
                  ship: ship,
                  isUnlocked: isUnlocked,
                  isSelected: isSelected,
                  credits: wallet.credits,
                  onSelect: () =>
                      ref.read(selectedShipProvider.notifier).select(ship.id),
                  onUnlock: () async {
                    final ok = await ref
                        .read(walletProvider.notifier)
                        .spend(ship.unlockCost);
                    if (ok) {
                      await ref
                          .read(unlockedShipsProvider.notifier)
                          .unlock(ship.id);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'UPGRADES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.4,
            children: UpgradeConfig.definitions.map((def) {
              final currentLevel = upgradeState.levelOf(def.type);
              final isMaxed = currentLevel >= def.maxLevel;
              final nextCost = isMaxed ? 0 : def.costForLevel(currentLevel + 1);
              final canAfford = !isMaxed && wallet.credits >= nextCost;

              return _UpgradeCell(
                def: def,
                currentLevel: currentLevel,
                cost: nextCost,
                isMaxed: isMaxed,
                canAfford: canAfford,
                onBuy: () async {
                  final ok = await ref
                      .read(walletProvider.notifier)
                      .spend(nextCost);
                  if (ok) {
                    await ref
                        .read(upgradeStateProvider.notifier)
                        .applyUpgrade(
                          upgradeState.withUpgrade(def.type, currentLevel + 1),
                        );
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
      ),
    );
  }
}

// Large hero display taking ~40% of screen
class _HeroShipDisplay extends StatelessWidget {
  final ShipDefinition ship;

  const _HeroShipDisplay({required this.ship});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
        color: const Color(0xFF060D1F),
      ),
      child: Stack(
        children: [
          // Large ship image fills the hero area
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/ship_${ship.id}.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.rocket_launch,
                  size: 120,
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          // Ship name at bottom
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xA0000000),
              ),
              child: Text(
                '${ship.displayName.toUpperCase()} - ${ship.description}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Compact ship card matching the mockup
class _ShipCard extends StatelessWidget {
  final ShipDefinition ship;
  final bool isUnlocked;
  final bool isSelected;
  final int credits;
  final VoidCallback onSelect;
  final VoidCallback onUnlock;

  const _ShipCard({
    required this.ship,
    required this.isUnlocked,
    required this.isSelected,
    required this.credits,
    required this.onSelect,
    required this.onUnlock,
  });

  Color get _borderColor {
    if (isSelected) return const Color(0xFF00E5FF);
    if (!isUnlocked) return Colors.white24;
    return const Color(0xFF7C4DFF);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked
          ? onSelect
          : (credits >= ship.unlockCost ? onUnlock : null),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor, width: isSelected ? 2 : 1),
          color: const Color(0xFF000000),
        ),
        child: Column(
          children: [
            // Ship name
            Text(
              ship.displayName.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? _borderColor : Colors.white54,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            // Thumbnail - compact
            SizedBox(
              height: 55,
              child: Image.asset(
                'assets/images/ship_${ship.id}_thumb.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  isUnlocked ? Icons.rocket_launch : Icons.lock,
                  size: 30,
                  color: isUnlocked
                      ? _borderColor.withValues(alpha: 0.5)
                      : Colors.white24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Stats - compact rows
            _statRow('HP', ship.baseStats.maxHp.toString()),
            _statRow('SPEED', (ship.baseStats.speed / 10).round().toString()),
            _statRow('DAMAGE', ship.baseStats.bulletDamage.toString()),
            _statRow(
              'FIRE RATE',
              ((1 / ship.baseStats.fireCooldown) * 10).round().toString(),
            ),
            const Spacer(),
            // Action button
            _buildAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildAction() {
    if (isSelected) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
        ),
        child: const Text(
          'ACTIVE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
          ),
        ),
      );
    }
    if (isUnlocked) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF7C4DFF).withValues(alpha: 0.15),
        ),
        child: const Text(
          'UNLOCKED',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C4DFF),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: credits >= ship.unlockCost
            ? const Color(0xFF7C4DFF)
            : Colors.white10,
      ),
      child: Text(
        'UNLOCK (${ship.unlockCost} CR)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: credits >= ship.unlockCost ? Colors.white : Colors.white38,
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 8, color: Colors.white38),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? const Color(0xFF00E5FF) : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeCell extends StatelessWidget {
  final UpgradeDefinition def;
  final int currentLevel;
  final int cost;
  final bool isMaxed;
  final bool canAfford;
  final VoidCallback onBuy;

  const _UpgradeCell({
    required this.def,
    required this.currentLevel,
    required this.cost,
    required this.isMaxed,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF000000),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(def.type.icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  def.type.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              if (isMaxed)
                const Text(
                  'MAX',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                )
              else
                GestureDetector(
                  onTap: canAfford ? onBuy : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: canAfford
                          ? const Color(0xFF7C4DFF)
                          : Colors.white10,
                    ),
                    child: Text(
                      '$cost CR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(def.maxLevel, (i) {
              return Container(
                width: 14,
                height: 5,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: i < currentLevel
                      ? const Color(0xFF00E5FF)
                      : const Color(0xFF00E5FF).withValues(alpha: 0.15),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
