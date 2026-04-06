class CurrencyWallet {
  final int credits;

  const CurrencyWallet({this.credits = 0});

  CurrencyWallet add(int amount) => CurrencyWallet(credits: credits + amount);

  CurrencyWallet spend(int amount) {
    assert(amount <= credits, 'Insufficient credits');
    return CurrencyWallet(credits: credits - amount);
  }

  bool canAfford(int cost) => credits >= cost;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyWallet &&
          runtimeType == other.runtimeType &&
          credits == other.credits;

  @override
  int get hashCode => credits.hashCode;
}
