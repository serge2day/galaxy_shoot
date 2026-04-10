import 'package:flutter/material.dart';

import 'strings_de.dart';
import 'strings_en.dart';
import 'strings_es.dart';
import 'strings_ru.dart';
import 'strings_zh.dart';

class AppLocalizations {
  final Locale locale;
  final Map<String, String> _strings;

  AppLocalizations(this.locale, this._strings);

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('ru'),
    Locale('es'),
    Locale('zh'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String _t(String key) => _strings[key] ?? stringsEn[key] ?? key;
  String _fmt(String key, Map<String, Object> args) {
    var s = _t(key);
    args.forEach((k, v) => s = s.replaceAll('{$k}', '$v'));
    return s;
  }

  // ---- Common ----
  String get campaign => _t('campaign');
  String get endlessGalaxy => _t('endlessGalaxy');
  String get hangar => _t('hangar');
  String get settings => _t('settings');
  String get about => _t('about');
  String get best => _t('best');
  String get credits => _t('credits');
  String get ship => _t('ship');
  String get home => _t('home');
  String get back => _t('back');
  String get cancel => _t('cancel');
  String get next => _t('next');
  String get skip => _t('skip');
  String get reset => _t('reset');

  // ---- Tutorial ----
  String get tut1Title => _t('tut1Title');
  String get tut1Body => _t('tut1Body');
  String get tut2Title => _t('tut2Title');
  String get tut2Body => _t('tut2Body');
  String get tut3Title => _t('tut3Title');
  String get tut3Body => _t('tut3Body');
  String get tut4Title => _t('tut4Title');
  String get tut4Body => _t('tut4Body');
  String get startPlaying => _t('startPlaying');

  // ---- About ----
  String get aboutGameSection => _t('aboutGameSection');
  String get aboutGameBody => _t('aboutGameBody');
  String get contactSection => _t('contactSection');
  String get contactBody => _t('contactBody');
  String get creditsSection => _t('creditsSection');
  String get creditsBody => _t('creditsBody');
  String get privacyPolicySection => _t('privacyPolicySection');
  String get dataStorageSection => _t('dataStorageSection');
  String get dataStorageBody => _t('dataStorageBody');

  // ---- Settings ----
  String get fireModeSection => _t('fireModeSection');
  String get autoFire => _t('autoFire');
  String get autoFireDesc => _t('autoFireDesc');
  String get manualFire => _t('manualFire');
  String get manualFireDesc => _t('manualFireDesc');
  String get audioHapticsSection => _t('audioHapticsSection');
  String get music => _t('music');
  String get musicVolume => _t('musicVolume');
  String get soundEffects => _t('soundEffects');
  String get sfxVolume => _t('sfxVolume');
  String get haptics => _t('haptics');
  String get tutorialSection => _t('tutorialSection');
  String get replayTutorial => _t('replayTutorial');
  String get tutorialWillShow => _t('tutorialWillShow');
  String get dataSection => _t('dataSection');
  String get resetAllProgress => _t('resetAllProgress');
  String get resetWarning => _t('resetWarning');
  String get resetDialogTitle => _t('resetDialogTitle');
  String get resetDialogBody => _t('resetDialogBody');
  String get progressReset => _t('progressReset');

  // ---- Run summary ----
  String get victory => _t('victory');
  String get gameOver => _t('gameOver');
  String get creditsEarned => _t('creditsEarned');
  String get newBest => _t('newBest');
  String get playAgain => _t('playAgain');
  String get nextStage => _t('nextStage');
  String get scoreLabel => _t('scoreLabel');
  String get shipLabel => _t('shipLabel');
  String get stageLabel => _t('stageLabel');
  String get difficultyLabel => _t('difficultyLabel');
  String get enemiesDefeated => _t('enemiesDefeated');
  String get peakEvolution => _t('peakEvolution');
  String evolutionLevel(int n) => _fmt('evolutionLevel', {'n': n});
  String get enemyKills => _t('enemyKills');
  String get bossDefeat => _t('bossDefeat');
  String get victoryBonus => _t('victoryBonus');
  String get difficultyBonus => _t('difficultyBonus');

  // ---- Stage select ----
  String get selectStage => _t('selectStage');
  String bestWithScore(int n) => _fmt('bestWithScore', {'n': n});

  // ---- Stages ----
  String stageName(int n) => _t('stage${n}Name');
  String stageSubtitle(int n) => _t('stage${n}Subtitle');

  // ---- Difficulty ----
  String get selectDifficulty => _t('selectDifficulty');
  String get chooseChallenge => _t('chooseChallenge');
  String get difficultyNormal => _t('difficultyNormal');
  String get difficultyVeteran => _t('difficultyVeteran');
  String get difficultyExpert => _t('difficultyExpert');
  String get difficultyNormalDesc => _t('difficultyNormalDesc');
  String get difficultyVeteranDesc => _t('difficultyVeteranDesc');
  String get difficultyExpertDesc => _t('difficultyExpertDesc');

  // ---- Endless ----
  String get highest => _t('highest');
  String sectorNumber(int n) => _fmt('sectorNumber', {'n': n});
  String missionCount(int n) => _fmt('missionCount', {'n': n});
  String get beginEndlessRun => _t('beginEndlessRun');
  String enterSector(int n) => _fmt('enterSector', {'n': n});
  String get locked => _t('locked');

  // ---- Biomes ----
  String biome(String id) => _t('biome_$id');

  // ---- Modifiers ----
  String modifier(String id) => _t('mod_$id');

  // ---- Hangar ----
  String get shipSelection => _t('shipSelection');
  String get upgrades => _t('upgrades');
  String get statHp => _t('statHp');
  String get statSpeed => _t('statSpeed');
  String get statDamage => _t('statDamage');
  String get statFireRate => _t('statFireRate');
  String get active => _t('active');
  String get unlockedLabel => _t('unlockedLabel');
  String unlockCost(int n) => _fmt('unlockCost', {'n': n});
  String get maxLabel => _t('maxLabel');

  // ---- Ships ----
  String shipName(String id) => _t('ship_${id}_name');
  String shipDesc(String id) => _t('ship_${id}_desc');

  // ---- Upgrades ----
  String upgradeName(String id) => _t('upgrade_${id}_name');

  // ---- Language ----
  String get languageSection => _t('languageSection');
  String get languageSystem => _t('languageSystem');

  // ---- Pause / results / missions ----
  String get paused => _t('paused');
  String get resume => _t('resume');
  String get restart => _t('restart');
  String get sectorCleared => _t('sectorCleared');
  String get runOver => _t('runOver');
  String get nextSectorBtn => _t('nextSectorBtn');
  String get sectorLabel => _t('sectorLabel');
  String get missionsCleared => _t('missionsCleared');
  String missionNumber(int n) => _fmt('missionNumber', {'n': n});
  String missionType(String id) => _t('mission_$id');

  // ---- HUD ----
  String hudScore(int n) => _fmt('hudScore', {'n': n});
  String hudLives(int n) => _fmt('hudLives', {'n': n});
  String hudEvo(int n) => _fmt('hudEvo', {'n': n});
  String get hudOverdrive => _t('hudOverdrive');
  String hudBomb(int n) => _fmt('hudBomb', {'n': n});
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final strings = switch (locale.languageCode) {
      'de' => stringsDe,
      'ru' => stringsRu,
      'es' => stringsEs,
      'zh' => stringsZh,
      _ => stringsEn,
    };
    // Install for global (non-context) access by game code.
    GameStrings.install(AppLocalizations(locale, strings));
    return AppLocalizations(locale, strings);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Global locale-aware string accessor for code without a BuildContext
/// (e.g. Flame components). Updated by the localizations delegate on load.
class GameStrings {
  static AppLocalizations? _current;

  static void install(AppLocalizations loc) {
    _current = loc;
  }

  static AppLocalizations get t =>
      _current ?? AppLocalizations(const Locale('en'), stringsEn);
}
