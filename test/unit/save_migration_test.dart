import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/core/persistence/save_migration.dart';

import '../helpers/test_helpers.dart';

void main() {
  test('migration sets version to current when starting from 0', () async {
    final repo = FakeProgressionRepository();
    // Simulate Phase 1 state (version 0)
    await repo.setSaveVersion(0);

    await SaveMigration(repo).migrate();
    expect(await repo.getSaveVersion(), SaveMigration.currentVersion);
  });

  test('migration is idempotent', () async {
    final repo = FakeProgressionRepository();
    await repo.setSaveVersion(0);

    await SaveMigration(repo).migrate();
    await SaveMigration(repo).migrate();
    expect(await repo.getSaveVersion(), SaveMigration.currentVersion);
  });

  test('does nothing if already at current version', () async {
    final repo = FakeProgressionRepository();
    await repo.setSaveVersion(SaveMigration.currentVersion);

    await SaveMigration(repo).migrate();
    expect(await repo.getSaveVersion(), SaveMigration.currentVersion);
  });

  test('current version is 2', () {
    expect(SaveMigration.currentVersion, 2);
  });
}
