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

void _setPhoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
}

void main() {
  testWidgets('displays HANGAR title', (tester) async {
    _setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('HANGAR'), findsOneWidget);
  });

  testWidgets('displays SHIP SELECTION section', (tester) async {
    _setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('SHIP SELECTION'), findsOneWidget);
  });

  testWidgets('vanguard shows ACTIVE badge', (tester) async {
    _setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('ACTIVE'), findsOneWidget);
  });

  testWidgets('displays credits in header', (tester) async {
    _setPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();
    expect(find.text('0 CR'), findsOneWidget);
  });
}
