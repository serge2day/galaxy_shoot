import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/providers.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';
import 'package:galaxy_shoot/features/settings/domain/settings_repository.dart';
import 'package:galaxy_shoot/features/settings/presentation/settings_screen.dart';
import 'package:galaxy_shoot/features/high_score/domain/high_score_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  GameSettings _settings = const GameSettings();

  @override
  Future<GameSettings> load() async => _settings;

  @override
  Future<void> save(GameSettings settings) async => _settings = settings;
}

class FakeHighScoreRepository implements HighScoreRepository {
  @override
  Future<int> getBestScore() async => 0;
  @override
  Future<void> saveBestScore(int score) async {}
}

Widget _buildApp() {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
      highScoreRepositoryProvider.overrideWithValue(FakeHighScoreRepository()),
    ],
    child: MaterialApp(theme: AppTheme.darkTheme, home: const SettingsScreen()),
  );
}

void main() {
  testWidgets('displays settings title', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('SETTINGS'), findsOneWidget);
  });

  testWidgets('displays fire mode options', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Auto Fire'), findsOneWidget);
    expect(find.text('Manual Fire'), findsOneWidget);
  });

  testWidgets('tapping manual fire selects it', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manual Fire'));
    await tester.pumpAndSettle();
    // Manual Fire option should now be selected (checked icon)
    final manualIcons = find.byIcon(Icons.radio_button_checked);
    expect(manualIcons, findsOneWidget);
  });
}
