import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/providers.dart';
import 'package:galaxy_shoot/app/routes.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/home/presentation/home_screen.dart';

import '../helpers/test_helpers.dart';

Widget _buildApp({int bestScore = 0}) {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
      highScoreRepositoryProvider.overrideWithValue(
        FakeHighScoreRepository(bestScore),
      ),
      progressionRepositoryProvider.overrideWithValue(
        FakeProgressionRepository(),
      ),
      shipCatalogRepositoryProvider.overrideWithValue(
        FakeShipCatalogRepository(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      routes: {
        AppRoutes.settings: (_) => const Scaffold(body: Text('Settings')),
        AppRoutes.game: (_) => const Scaffold(body: Text('Game')),
        AppRoutes.hangar: (_) => const Scaffold(body: Text('Hangar')),
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

  testWidgets('displays HANGAR button', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('HANGAR'), findsOneWidget);
  });

  testWidgets('displays credits', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('CREDITS'), findsOneWidget);
  });

  testWidgets('displays selected ship name', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Vanguard'), findsOneWidget);
  });

  testWidgets('navigates to settings when button tapped', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('SETTINGS'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('navigates to hangar when button tapped', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('HANGAR'));
    await tester.pumpAndSettle();
    expect(find.text('Hangar'), findsOneWidget);
  });
}
