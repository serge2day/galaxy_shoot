import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/providers.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/settings/presentation/settings_screen.dart';

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

  testWidgets('displays audio toggles', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);
    expect(find.text('Haptics'), findsOneWidget);
  });

  testWidgets('displays reset progress button', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('RESET ALL PROGRESS'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('RESET ALL PROGRESS'), findsOneWidget);
  });
}
