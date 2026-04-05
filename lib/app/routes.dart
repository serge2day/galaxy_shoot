import 'package:flutter/material.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'game_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String settings = '/settings';
  static const String game = '/game';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    settings: (_) => const SettingsScreen(),
    game: (_) => const GamePage(),
  };
}
