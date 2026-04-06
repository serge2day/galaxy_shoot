import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/progression/data/local_progression_repository.dart';
import 'package:galaxy_shoot/features/progression/domain/currency_wallet.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_state.dart';
import 'package:galaxy_shoot/features/progression/domain/upgrade_type.dart';

import '../helpers/test_helpers.dart';

void main() {
  late InMemoryStore store;
  late LocalProgressionRepository repo;

  setUp(() {
    store = InMemoryStore();
    repo = LocalProgressionRepository(store);
  });

  test('wallet defaults to 0 credits', () async {
    final wallet = await repo.getWallet();
    expect(wallet.credits, 0);
  });

  test('saves and loads wallet', () async {
    await repo.saveWallet(const CurrencyWallet(credits: 500));
    final loaded = await repo.getWallet();
    expect(loaded.credits, 500);
  });

  test('upgrade state defaults to empty', () async {
    final state = await repo.getUpgradeState();
    expect(state.levelOf(UpgradeType.maxHp), 0);
    expect(state.levelOf(UpgradeType.fireRate), 0);
  });

  test('saves and loads upgrade state', () async {
    final state = const UpgradeState()
        .withUpgrade(UpgradeType.maxHp, 3)
        .withUpgrade(UpgradeType.fireRate, 2);
    await repo.saveUpgradeState(state);

    final loaded = await repo.getUpgradeState();
    expect(loaded.levelOf(UpgradeType.maxHp), 3);
    expect(loaded.levelOf(UpgradeType.fireRate), 2);
    expect(loaded.levelOf(UpgradeType.bulletDamage), 0);
  });

  test('save version defaults to 0', () async {
    expect(await repo.getSaveVersion(), 0);
  });

  test('persists save version', () async {
    await repo.setSaveVersion(2);
    expect(await repo.getSaveVersion(), 2);
  });
}
