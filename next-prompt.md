# STARVANE — Next Prompt

Paste this into a fresh Claude Code session inside `C:\Users\serge\APPS\galaxy_shoot` to continue development.

---

## Where we are

STARVANE is release-candidate quality:

- 9-stage campaign + Endless Galaxy mode (6 biomes, 7 mission types, sector modifiers)
- 6 ships, 5 enemy families + elites, 3 bosses with 3-phase fights
- In-run evolution (5 levels, overdrive), bombs, pickups, 4 global upgrade lines
- Native Android SoundPool SFX + FlameAudio BGM, per-sound volume, settings persistence
- Native Android haptics via MethodChannel (matches Blockfall pattern)
- i18n for 5 languages (en/de/ru/es/zh), in-settings language switcher
- Responsive scaling, portrait-only, first-run tutorial, about/privacy
- Offline-first, no analytics, no network, save schema v5 with migration
- 172 automated tests

Latest commits:
- `2882466` Scale endless enemies with sector/mission progression
- `784617c` End non-boss missions instantly; extend shield to 15s
- `0227c14` Add language switcher in settings

## What to do next — pick ONE track

### Track A (recommended): iOS parity pass

Audio and haptics are wired through Android-only `MethodChannel`s
(`MainActivity.kt` → `SoundPool`, separate vibration channel). iOS currently
falls back to whatever the Dart side does and likely has no SFX + no haptics.

Goals:
1. Add `ios/Runner/AppDelegate.swift` `FlutterMethodChannel` handlers mirroring
   the Android SFX contract (load, play, stop, release) using `AVAudioEngine` +
   `AVAudioPlayerNode` **or** a pool of `AVAudioPlayer` instances. Must not steal
   audio focus from Music/Spotify (`AVAudioSession` category `.ambient` with
   `.mixWithOthers`).
2. Add a second channel for haptics using `UIImpactFeedbackGenerator` /
   `UINotificationFeedbackGenerator`, matching the light/medium/heavy/selection
   calls the Dart `HapticsService` already makes.
3. Verify `flutter build ios --release --no-codesign` succeeds and run on a
   real device: SFX fire/hit/death, BGM ducking on background, haptics on move
   and hit.
4. Update `docs/QA_TEST_MATRIX.md` with iOS rows.

Do **not** introduce a Dart audio plugin for SFX — the Android pattern
documented in the workspace `CLAUDE.md` is the contract.

### Track B: Daily Challenge mode (Blockfall-style)

Add a seeded daily run that every player gets the same version of:

1. New feature folder `lib/features/daily/` with `domain/daily_seed.dart`
   (date → deterministic seed), `data/daily_repository.dart` (best score per
   date, keyed in SharedPreferences), `presentation/daily_entry_screen.dart`.
2. Wire into home screen as a third card next to Campaign / Endless.
3. Reuse endless generators but force RNG seed = `yyyyMMdd` hash, fixed ship,
   fixed difficulty, 5 missions.
4. Show today's best, yesterday's best, and current streak on the entry screen.
5. Add tests for seed stability (same date → same waves across runs).

### Track C: Achievements (local, offline)

1. `lib/features/achievements/` with `domain/achievement.dart` + a static list
   (~20 achievements: first boss kill, evolve to max, clear sector without
   losing a life, 10k credits earned, unlock all ships, etc.).
2. `data/achievements_repository.dart` persisting unlocked IDs + timestamps.
3. Event hooks in `GalaxyGame` / `EndlessGamePage` to fire unlocks.
4. Toast popup on unlock (reuse existing overlay style).
5. Achievements list screen reachable from home or about.
6. i18n strings across all 5 locales.

### Track D: Accessibility pass

1. Colorblind-safe palette option in settings (affects enemy/pickup tints).
2. High-contrast HUD toggle.
3. Larger fire button option.
4. Reduce-flash option (dampens muzzle flash, hit flash, screen shake).
5. Persist in settings, respect everywhere in `game/components/effects/`.

## Before you start

- Read `CLAUDE.md` at the workspace root — especially the audio and Sudoku
  sections — for binding patterns.
- Read `PHASE3_TECH_NOTE.md` for the endless-mode architecture rationale.
- Run `flutter analyze && flutter test` to confirm a clean baseline before
  touching code.
- Do not add analytics, network calls, or cloud sync — offline-first is a
  product constraint.
- Do not switch engines (Flame stays), do not introduce a second i18n system,
  do not replace the audio architecture.

## Definition of done for whichever track you pick

- [ ] `flutter analyze` clean
- [ ] `flutter test` green (add tests for new logic)
- [ ] Manual run on Android device passes (iOS too for Track A)
- [ ] New strings added to all 5 locales if UI text is introduced
- [ ] `README.md` updated with the new feature
- [ ] Single focused commit per logical chunk, conventional style matching
      recent history (e.g. `Add daily challenge mode with seeded runs`)

Tell me which track you want before writing code.
