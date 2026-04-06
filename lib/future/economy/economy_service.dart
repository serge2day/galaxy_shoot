abstract class EconomyService {
  int getBalance();
  Future<void> addCurrency(int amount);
  Future<bool> spend(int amount);
}
