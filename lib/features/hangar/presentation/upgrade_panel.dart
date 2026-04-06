import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../progression/domain/upgrade_definition.dart';
import '../../progression/domain/upgrade_state.dart';
import '../../progression/domain/upgrade_type.dart';

class UpgradePanel extends StatelessWidget {
  final UpgradeState upgradeState;
  final int credits;
  final void Function(UpgradeType type) onPurchase;

  const UpgradePanel({
    super.key,
    required this.upgradeState,
    required this.credits,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'UPGRADES',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...UpgradeConfig.definitions.map((def) => _buildUpgradeRow(def)),
      ],
    );
  }

  Widget _buildUpgradeRow(UpgradeDefinition def) {
    final currentLevel = upgradeState.levelOf(def.type);
    final isMaxed = currentLevel >= def.maxLevel;
    final nextCost = isMaxed ? 0 : def.costForLevel(currentLevel + 1);
    final canAfford = !isMaxed && credits >= nextCost;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.bgCard,
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(def.type.icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.type.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                _buildLevelDots(currentLevel, def.maxLevel),
              ],
            ),
          ),
          if (isMaxed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.successColor.withValues(alpha: 0.15),
              ),
              child: const Text(
                'MAX',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                  letterSpacing: 1,
                ),
              ),
            )
          else
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: canAfford ? () => onPurchase(def.type) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford
                      ? AppTheme.accentColor
                      : Colors.white10,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                child: Text('$nextCost CR'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLevelDots(int current, int max) {
    return Row(
      children: List.generate(max, (i) {
        final filled = i < current;
        return Container(
          width: 12,
          height: 6,
          margin: const EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: filled
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withValues(alpha: 0.15),
          ),
        );
      }),
    );
  }
}
