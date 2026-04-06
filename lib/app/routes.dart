import 'package:flutter/material.dart';

import '../features/about/presentation/about_screen.dart';
import '../features/campaign/presentation/stage_select_screen.dart';
import '../features/hangar/presentation/hangar_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'game_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String settings = '/settings';
  static const String game = '/game';
  static const String hangar = '/hangar';
  static const String stageSelect = '/stage-select';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    settings: (_) => const SettingsScreen(),
    game: (_) => const GamePage(),
    hangar: (_) => const HangarScreen(),
    stageSelect: (_) => const StageSelectScreen(),
    about: (_) => const AboutScreen(),
  };
}
