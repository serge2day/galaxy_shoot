import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/game_audio.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class GalaxyShooterApp extends ConsumerStatefulWidget {
  const GalaxyShooterApp({super.key});

  @override
  ConsumerState<GalaxyShooterApp> createState() => _GalaxyShooterAppState();
}

class _GalaxyShooterAppState extends ConsumerState<GalaxyShooterApp>
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

    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'STARVANE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
