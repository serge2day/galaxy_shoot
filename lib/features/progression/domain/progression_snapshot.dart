import 'currency_wallet.dart';
import 'upgrade_state.dart';

class ProgressionSnapshot {
  final CurrencyWallet wallet;
  final int bestScore;
  final UpgradeState upgrades;
  final List<String> unlockedShipIds;
  final String selectedShipId;
  final int saveVersion;

  const ProgressionSnapshot({
    required this.wallet,
    required this.bestScore,
    required this.upgrades,
    required this.unlockedShipIds,
    required this.selectedShipId,
    required this.saveVersion,
  });
}
