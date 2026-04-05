import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/progression/domain/currency_wallet.dart';

void main() {
  test('default wallet has 0 credits', () {
    const wallet = CurrencyWallet();
    expect(wallet.credits, 0);
  });

  test('add increases credits', () {
    const wallet = CurrencyWallet(credits: 100);
    final updated = wallet.add(50);
    expect(updated.credits, 150);
  });

  test('spend decreases credits', () {
    const wallet = CurrencyWallet(credits: 200);
    final updated = wallet.spend(80);
    expect(updated.credits, 120);
  });

  test('canAfford returns true when sufficient', () {
    const wallet = CurrencyWallet(credits: 100);
    expect(wallet.canAfford(100), true);
    expect(wallet.canAfford(50), true);
  });

  test('canAfford returns false when insufficient', () {
    const wallet = CurrencyWallet(credits: 50);
    expect(wallet.canAfford(100), false);
  });

  test('equality works', () {
    const a = CurrencyWallet(credits: 100);
    const b = CurrencyWallet(credits: 100);
    const c = CurrencyWallet(credits: 200);
    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
