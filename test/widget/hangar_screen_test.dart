import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/providers.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/hangar/presentation/hangar_screen.dart';

import '../helpers/test_helpers.dart';

Widget _buildApp() {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
      highScoreRepositoryProvider.overrideWithValue(FakeHighScoreRepository()),
      progressionRepositoryProvider.overrideWithValue(
        FakeProgressionRepository(),
      ),
      shipCatalogRepositoryProvider.overrideWithValue(
        FakeShipCatalogRepository(),
      ),
      campaignRepositoryProvider.overrideWithValue(FakeCampaignRepository()),
    ],
    child: MaterialApp(theme: AppTheme.darkTheme, home: const HangarScreen()),
  );
}

void main() {
  testWidgets('displays HANGAR title', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('HANGAR'), findsOneWidget);
  });

  testWidgets('displays all ship names', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Vanguard'), findsOneWidget);
    expect(find.text('Phantom'), findsOneWidget);
    expect(find.text('Titan'), findsOneWidget);
  });

  testWidgets('displays SHIPS section', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('SHIPS'), findsOneWidget);
  });

  testWidgets('displays UPGRADES section', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('UPGRADES'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('UPGRADES'), findsOneWidget);
  });

  testWidgets('vanguard shows ACTIVE badge', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('ACTIVE'), findsOneWidget);
  });

  testWidgets('locked ships show UNLOCK button', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('UNLOCK'), findsNWidgets(2));
  });
}
