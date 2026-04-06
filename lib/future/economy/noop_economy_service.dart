import 'economy_service.dart';

class NoopEconomyService implements EconomyService {
  @override
  int getBalance() => 0;

  @override
  Future<void> addCurrency(int amount) async {}

  @override
  Future<bool> spend(int amount) async => false;
}
