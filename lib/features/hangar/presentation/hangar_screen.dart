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

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('HANGAR',
            style: TextStyle(fontSize: 22, letterSpacing: 2)),
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
          // Hero ship display
          _HeroShipDisplay(ship: selectedShip),
          const SizedBox(height: 16),
          // Ship selection label
          const Text(
            'SHIP SELECTION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Horizontal ship cards
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ShipCatalog.ships.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final ship = ShipCatalog.ships[index];
                final isUnlocked = unlockedIds.contains(ship.id);
                final isSelected = ship.id == selectedId;
                return _ShipCard(
                  ship: ship,
                  isUnlocked: isUnlocked,
                  isSelected: isSelected,
                  credits: wallet.credits,
                  onSelect: () => ref
                      .read(selectedShipProvider.notifier)
                      .select(ship.id),
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
          const SizedBox(height: 20),
          // Upgrades label
          const Text(
            'UPGRADES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Upgrade grid - 2 columns
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: UpgradeConfig.definitions.map((def) {
              final currentLevel = upgradeState.levelOf(def.type);
              final isMaxed = currentLevel >= def.maxLevel;
              final nextCost =
                  isMaxed ? 0 : def.costForLevel(currentLevel + 1);
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
                            upgradeState.withUpgrade(def.type, currentLevel + 1));
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _HeroShipDisplay extends StatelessWidget {
  final ShipDefinition ship;

  const _HeroShipDisplay({required this.ship});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A1628), Color(0xFF050A18)],
        ),
      ),
      child: Stack(
        children: [
          // Ship image if available, else icon
          Center(
            child: Image.asset(
              'assets/images/ship_${ship.id}.png',
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.rocket_launch,
                size: 100,
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          // Ship name overlay at top
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Text(
              '${ship.displayName.toUpperCase()}: ${ship.description}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      width: 155,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: isSelected ? 2 : 1),
        color: const Color(0xFF0E1525),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ship name
          Text(
            ship.displayName.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? _borderColor : Colors.white54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          // Ship image or icon
          SizedBox(
            height: 70,
            child: Image.asset(
              'assets/images/ship_${ship.id}_thumb.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                isUnlocked ? Icons.rocket_launch : Icons.lock,
                size: 40,
                color: isUnlocked
                    ? _borderColor.withValues(alpha: 0.6)
                    : Colors.white24,
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Stats
          _statRow('HP', ship.baseStats.maxHp.toString()),
          _statRow('SPEED', (ship.baseStats.speed / 10).round().toString()),
          _statRow('DAMAGE', ship.baseStats.bulletDamage.toString()),
          _statRow('FIRE RATE',
              ((1 / ship.baseStats.fireCooldown) * 10).round().toString()),
          const Spacer(),
          // Action
          if (isSelected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
              ),
              child: const Text(
                'ACTIVE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E5FF),
                  letterSpacing: 1,
                ),
              ),
            )
          else if (isUnlocked)
            GestureDetector(
              onTap: onSelect,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                ),
                child: const Text(
                  'UNLOCKED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: credits >= ship.unlockCost ? onUnlock : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: credits >= ship.unlockCost
                      ? const Color(0xFF7C4DFF)
                      : Colors.white10,
                ),
                child: Text(
                  'UNLOCK (${ship.unlockCost} CR)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: credits >= ship.unlockCost
                        ? Colors.white
                        : Colors.white38,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.white38),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
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
        color: const Color(0xFF0E1525),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        color:
                            canAfford ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          // Level dots
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
