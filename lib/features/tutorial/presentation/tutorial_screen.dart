import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _page = 0;

  static const _icons = [
    Icons.swipe,
    Icons.flash_on,
    Icons.star,
    Icons.warning_amber,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final titles = [l.tut1Title, l.tut2Title, l.tut3Title, l.tut4Title];
    final bodies = [l.tut1Body, l.tut2Body, l.tut3Body, l.tut4Body];
    final pageCount = titles.length;
    final isLast = _page == pageCount - 1;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(_icons[_page], size: 64, color: AppTheme.primaryColor),
              const SizedBox(height: 24),
              Text(
                titles[_page],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                bodies[_page],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageCount,
                  (i) => Container(
                    width: i == _page ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: i == _page
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      Navigator.of(context).pop(true);
                    } else {
                      setState(() => _page++);
                    }
                  },
                  child: Text(isLast ? l.startPlaying : l.next),
                ),
              ),
              if (!isLast)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    l.skip,
                    style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
