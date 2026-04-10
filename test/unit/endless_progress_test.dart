import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/endless/domain/endless_progress.dart';

void main() {
  test('starts unlocked false and zero records', () {
    const progress = EndlessProgress();
    expect(progress.unlocked, false);
    expect(progress.highestSector, 0);
    expect(progress.bestScore, 0);
  });

  test('withSectorCleared updates highest sector', () {
    const progress = EndlessProgress(unlocked: true);
    final updated = progress.withSectorCleared(3, 5000, 'vanguard');
    expect(updated.highestSector, 3);
    expect(updated.bestScore, 5000);
    expect(updated.perShipBestSector['vanguard'], 3);
  });

  test('withSectorCleared only updates if higher', () {
    var progress = const EndlessProgress(unlocked: true);
    progress = progress.withSectorCleared(5, 8000, 'vanguard');
    progress = progress.withSectorCleared(3, 4000, 'vanguard');
    expect(progress.highestSector, 5);
    expect(progress.bestScore, 8000);
    expect(progress.perShipBestSector['vanguard'], 5);
  });

  test('tracks per-ship records separately', () {
    var progress = const EndlessProgress(unlocked: true);
    progress = progress.withSectorCleared(5, 8000, 'vanguard');
    progress = progress.withSectorCleared(3, 4000, 'phantom');
    expect(progress.perShipBestSector['vanguard'], 5);
    expect(progress.perShipBestSector['phantom'], 3);
    expect(progress.highestSector, 5);
  });

  test('copyWith preserves fields', () {
    const progress = EndlessProgress(highestSector: 5, bestScore: 9000);
    final updated = progress.copyWith(unlocked: true);
    expect(updated.unlocked, true);
    expect(updated.highestSector, 5);
    expect(updated.bestScore, 9000);
  });
}
