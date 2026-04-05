import 'currency_wallet.dart';
import 'upgrade_state.dart';

abstract class ProgressionRepository {
  Future<CurrencyWallet> getWallet();
  Future<void> saveWallet(CurrencyWallet wallet);
  Future<UpgradeState> getUpgradeState();
  Future<void> saveUpgradeState(UpgradeState state);
  Future<int> getSaveVersion();
  Future<void> setSaveVersion(int version);
}
