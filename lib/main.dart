import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/persistence/save_migration.dart';
import 'core/persistence/shared_prefs_store.dart';
import 'features/progression/data/local_progression_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();

  // Run save migration
  final store = SharedPrefsStore(prefs);
  final progressionRepo = LocalProgressionRepository(store);
  await SaveMigration(progressionRepo).migrate();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const GalaxyShooterApp(),
    ),
  );
}
