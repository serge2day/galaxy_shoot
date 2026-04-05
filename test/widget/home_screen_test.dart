import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/providers.dart';
import 'package:galaxy_shoot/app/routes.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/home/presentation/home_screen.dart';
import 'package:galaxy_shoot/features/settings/domain/game_settings.dart';
import 'package:galaxy_shoot/features/settings/domain/settings_repository.dart';
import 'package:galaxy_shoot/features/high_score/domain/high_score_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  GameSettings _settings = const GameSettings();

  @override
  Future<GameSettings> load() async => _settings;

  @override
  Future<void> save(GameSettings settings) async => _settings = settings;
}

class FakeHighScoreRepository implements HighScoreRepository {
  int _score = 0;

  FakeHighScoreRepository([this._score = 0]);

  @override
  Future<int> getBestScore() async => _score;

  @override
  Future<void> saveBestScore(int score) async {
    if (score > _score) _score = score;
  }
}

Widget _buildApp({int bestScore = 0}) {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
      highScoreRepositoryProvider.overrideWithValue(
        FakeHighScoreRepository(bestScore),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      routes: {
        AppRoutes.settings: (_) => const Scaffold(body: Text('Settings')),
        AppRoutes.game: (_) => const Scaffold(body: Text('Game')),
      },
    ),
  );
}

void main() {
  testWidgets('displays game title', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('GALAXY\nSHOOTER'), findsOneWidget);
  });

  testWidgets('displays NEW GAME button', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('NEW GAME'), findsOneWidget);
  });

  testWidgets('displays SETTINGS button', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('SETTINGS'), findsOneWidget);
  });

  testWidgets('displays BEST SCORE label', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('BEST SCORE'), findsOneWidget);
  });

  testWidgets('displays best score value', (tester) async {
    await tester.pumpWidget(_buildApp(bestScore: 0));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('navigates to settings when button tapped', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('SETTINGS'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('navigates to game when NEW GAME tapped', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEW GAME'));
    await tester.pumpAndSettle();
    expect(find.text('Game'), findsOneWidget);
  });
}
