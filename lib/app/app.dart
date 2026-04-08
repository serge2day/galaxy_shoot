import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/services/game_audio.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class GalaxyShooterApp extends StatefulWidget {
  const GalaxyShooterApp({super.key});

  @override
  State<GalaxyShooterApp> createState() => _GalaxyShooterAppState();
}

class _GalaxyShooterAppState extends State<GalaxyShooterApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      GameAudio.pauseAll();
    } else if (state == AppLifecycleState.resumed) {
      GameAudio.resumeAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'STARVANE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
