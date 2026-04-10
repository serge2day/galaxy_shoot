import '../../../core/persistence/key_value_store.dart';
import '../domain/endless_progress.dart';

class LocalEndlessRepository {
  final KeyValueStore _store;

  static const String _unlockedKey = 'endless_unlocked';
  static const String _highestSectorKey = 'endless_highest_sector';
  static const String _bestScoreKey = 'endless_best_score';
  static const String _shipBestPrefix = 'endless_ship_best_';

  LocalEndlessRepository(this._store);

  Future<EndlessProgress> load() async {
    final unlocked = await _store.getString(_unlockedKey) == 'true';
    final highest = await _store.getInt(_highestSectorKey) ?? 0;
    final best = await _store.getInt(_bestScoreKey) ?? 0;

    final shipBests = <String, int>{};
    for (final shipId in [
      'vanguard',
      'striker',
      'guardian',
      'ravager',
      'phantom',
      'titan',
    ]) {
      final val = await _store.getInt('$_shipBestPrefix$shipId');
      if (val != null && val > 0) {
        shipBests[shipId] = val;
      }
    }

    return EndlessProgress(
      unlocked: unlocked,
      highestSector: highest,
      bestScore: best,
      perShipBestSector: shipBests,
    );
  }

  Future<void> save(EndlessProgress progress) async {
    await _store.setString(_unlockedKey, progress.unlocked.toString());
    await _store.setInt(_highestSectorKey, progress.highestSector);
    await _store.setInt(_bestScoreKey, progress.bestScore);
    for (final entry in progress.perShipBestSector.entries) {
      await _store.setInt('$_shipBestPrefix${entry.key}', entry.value);
    }
  }

  Future<void> unlock() async {
    await _store.setString(_unlockedKey, 'true');
  }

  Future<void> reset() async {
    await _store.remove(_unlockedKey);
    await _store.remove(_highestSectorKey);
    await _store.remove(_bestScoreKey);
    for (final shipId in [
      'vanguard',
      'striker',
      'guardian',
      'ravager',
      'phantom',
      'titan',
    ]) {
      await _store.remove('$_shipBestPrefix$shipId');
    }
  }
}
