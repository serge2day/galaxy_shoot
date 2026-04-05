import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/persistence/key_value_store.dart';
import 'package:galaxy_shoot/features/high_score/data/local_high_score_repository.dart';

class InMemoryStore implements KeyValueStore {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> setString(String key, String value) async => _data[key] = value;
  @override
  Future<String?> getString(String key) async => _data[key] as String?;
  @override
  Future<void> setInt(String key, int value) async => _data[key] = value;
  @override
  Future<int?> getInt(String key) async => _data[key] as int?;
  @override
  Future<void> remove(String key) async => _data.remove(key);
}

void main() {
  late InMemoryStore store;
  late LocalHighScoreRepository repo;

  setUp(() {
    store = InMemoryStore();
    repo = LocalHighScoreRepository(store);
  });

  test('returns 0 when no score saved', () async {
    expect(await repo.getBestScore(), 0);
  });

  test('saves and retrieves best score', () async {
    await repo.saveBestScore(500);
    expect(await repo.getBestScore(), 500);
  });

  test('only updates if new score is higher', () async {
    await repo.saveBestScore(500);
    await repo.saveBestScore(300);
    expect(await repo.getBestScore(), 500);
  });

  test('updates when new score is higher', () async {
    await repo.saveBestScore(500);
    await repo.saveBestScore(1000);
    expect(await repo.getBestScore(), 1000);
  });
}
