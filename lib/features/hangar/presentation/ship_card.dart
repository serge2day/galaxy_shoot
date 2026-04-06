import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../domain/ship_definition.dart';

class ShipCard extends StatelessWidget {
  final ShipDefinition ship;
  final bool isUnlocked;
  final bool isSelected;
  final int credits;
  final VoidCallback? onSelect;
  final VoidCallback? onUnlock;

  const ShipCard({
    super.key,
    required this.ship,
    required this.isUnlocked,
    required this.isSelected,
    required this.credits,
    this.onSelect,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor
              : isUnlocked
              ? AppTheme.primaryColor.withValues(alpha: 0.3)
              : Colors.white12,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? AppTheme.primaryColor.withValues(alpha: 0.08)
            : AppTheme.bgCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShipPreview(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ship.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ship.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatBars(),
          const SizedBox(height: 12),
          _buildAction(),
        ],
      ),
    );
  }

  Widget _buildShipPreview() {
    Color color;
    switch (ship.visualStyle) {
      case ShipVisualStyle.balanced:
        color = const Color(0xFF00E5FF);
        break;
      case ShipVisualStyle.striker:
      case ShipVisualStyle.phantom:
        color = const Color(0xFF69F0AE);
        break;
      case ShipVisualStyle.guardian:
        color = const Color(0xFF42A5F5);
        break;
      case ShipVisualStyle.ravager:
        color = const Color(0xFFFF5252);
        break;
      case ShipVisualStyle.titan:
        color = const Color(0xFFFF9100);
        break;
    }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isUnlocked ? 0.15 : 0.05),
        border: Border.all(
          color: color.withValues(alpha: isUnlocked ? 0.4 : 0.15),
        ),
      ),
      child: Icon(
        isUnlocked ? Icons.rocket_launch : Icons.lock,
        color: color.withValues(alpha: isUnlocked ? 0.8 : 0.4),
        size: 24,
      ),
    );
  }

  Widget _buildStatBars() {
    final stats = ship.baseStats;
    return Row(
      children: [
        _statLabel('HP', stats.maxHp / 10),
        const SizedBox(width: 8),
        _statLabel('SPD', stats.speed / 700),
        const SizedBox(width: 8),
        _statLabel('DMG', stats.bulletDamage / 3),
        const SizedBox(width: 8),
        _statLabel('ROF', (1 - stats.fireCooldown / 0.3)),
      ],
    );
  }

  Widget _statLabel(String label, double ratio) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1,
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(
                isUnlocked ? AppTheme.primaryColor : Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    if (!isUnlocked) {
      final canAfford = credits >= ship.unlockCost;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canAfford ? onUnlock : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canAfford ? AppTheme.accentColor : Colors.white10,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            'UNLOCK  ${ship.unlockCost} CR',
            style: const TextStyle(fontSize: 13, letterSpacing: 0.5),
          ),
        ),
      );
    }

    if (isSelected) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onSelect,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: const BorderSide(color: AppTheme.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: const Text(
          'SELECT',
          style: TextStyle(fontSize: 13, letterSpacing: 1),
        ),
      ),
    );
  }
}
