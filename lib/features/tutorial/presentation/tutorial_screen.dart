import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _page = 0;

  static const _pages = [
    _TutorialPage(
      icon: Icons.swipe,
      title: 'DRAG TO MOVE',
      body:
          'Touch and drag anywhere to move your ship.\nStay mobile to avoid enemy fire.',
    ),
    _TutorialPage(
      icon: Icons.flash_on,
      title: 'FIRE & DESTROY',
      body:
          'Your ship fires automatically in Auto mode.\nSwitch to Manual in Settings for a fire button.',
    ),
    _TutorialPage(
      icon: Icons.star,
      title: 'COLLECT PICKUPS',
      body:
          'Defeated enemies may drop pickups:\nW = Weapon Boost  S = Shield  H = Heal',
    ),
    _TutorialPage(
      icon: Icons.warning_amber,
      title: 'DEFEAT THE BOSS',
      body:
          'Each stage ends with a boss fight.\nWatch for phase changes and dodge patterns.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final page = _pages[_page];
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(page.icon, size: 64, color: AppTheme.primaryColor),
              const SizedBox(height: 24),
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              // Page dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
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
                  child: Text(isLast ? 'START PLAYING' : 'NEXT'),
                ),
              ),
              if (!isLast)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'SKIP',
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

class _TutorialPage {
  final IconData icon;
  final String title;
  final String body;

  const _TutorialPage({
    required this.icon,
    required this.title,
    required this.body,
  });
}
