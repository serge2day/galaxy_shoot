import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/app/theme/app_theme.dart';
import 'package:galaxy_shoot/features/progression/domain/difficulty_tier.dart';
import 'package:galaxy_shoot/features/progression/presentation/difficulty_select_screen.dart';

void main() {
  testWidgets('displays all difficulty tiers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DifficultySelectScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('NORMAL'), findsOneWidget);
    expect(find.text('VETERAN'), findsOneWidget);
    expect(find.text('EXPERT'), findsOneWidget);
  });

  testWidgets('displays reward multipliers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const DifficultySelectScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('x1.0'), findsOneWidget);
    expect(find.text('x1.5'), findsOneWidget);
    expect(find.text('x2.5'), findsOneWidget);
  });

  testWidgets('tapping a tier returns it', (tester) async {
    DifficultyTier? selected;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              selected = await Navigator.of(context).push<DifficultyTier>(
                MaterialPageRoute(
                  builder: (_) => const DifficultySelectScreen(),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('VETERAN'));
    await tester.pumpAndSettle();

    expect(selected, DifficultyTier.veteran);
  });
}
