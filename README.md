# Galaxy Shooter v1.0

A portrait-mode mobile arcade space shooter built with Flutter and Flame. Three stages, three ships, three difficulty tiers, persistent progression, and a complete offline campaign ready for App Store and Google Play.

## Game Overview

Battle through three handcrafted stages, each with unique enemy compositions and a distinct boss fight. Unlock ships, purchase upgrades, and climb difficulty tiers for better rewards.

## v1.0 Content

- **3 Stages**: Frontier, Nebula, Dark Core - each with unique wave compositions and bosses
- **3 Ships**: Vanguard (balanced), Phantom (fast/agile), Titan (slow/tough)
- **3 Enemy Families**: Drone (baseline), Interceptor (fast/aggressive), Gunship (heavy/tanky)
- **3 Bosses**: One per stage with 3 behavior phases each
- **3 Difficulty Tiers**: Normal, Veteran, Expert
- **3 Pickup Types**: Weapon Boost, Shield, Heal
- **4 Upgrade Lines**: Max HP, Fire Rate, Bullet Damage, Movement Speed (5 levels each)
- **Persistent Progression**: Credits, ship unlocks, upgrades, stage clears, best scores
- **Tutorial**: Lightweight first-run onboarding
- **Settings**: Fire mode, music/SFX/haptics toggles, reset progress, replay tutorial

## Architecture

```
lib/
  main.dart
  app/                          # App shell, routes, providers, theme
  core/
    config/                     # Balance values, constants
    persistence/                # KeyValueStore, SharedPrefs, save migration (v3)
    services/                   # Audio, haptics, analytics (interfaces + implementations)
    utils/                      # Math helpers, extensions
  features/
    home/                       # Home screen
    settings/                   # Fire mode, audio/haptics toggles, reset
    about/                      # Privacy, version, contact info
    high_score/                 # Overall best score
    session/                    # RunResult model
    hangar/                     # Ships, stats, upgrades, ship catalog
    progression/                # Wallet, difficulty, rewards, upgrade definitions
    campaign/                   # Stage progress, stage select, campaign repository
    tutorial/                   # First-run tutorial screens
  game/
    galaxy_game.dart            # FlameGame: state, stats, stage, difficulty
    world/
      galaxy_world.dart         # World component, spawning, input
      stages/                   # Stage definitions (01, 02, 03), registry
      spawn_timeline.dart       # Legacy timeline (backward compat)
    components/
      background/               # Parallax starfield (per-stage tint)
      player/                   # PlayerShip (3 styles), weapon, pickup handling
      enemies/                  # EnemyShip (3 types), EnemyType, weapon
      boss/                     # BossShip (3 visuals, 3 phases), weapon, health bar
      pickups/                  # PickupItem, PickupType
      effects/                  # ExplosionEffect, HitFlash
      projectiles/              # PlayerBullet, EnemyBullet
      ui/                       # HUD, fire button
  future/                       # Placeholder interfaces
docs/                           # Release docs
```

## Dependencies

| Package | Purpose |
|---------|---------|
| flame | 2D game engine |
| flutter_riverpod | State management / DI |
| shared_preferences | Local persistence |
| flutter_lints | Lint rules |

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter analyze
flutter test
```

## Build Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release --no-codesign
```

## What's Stored Locally

- Game settings (fire mode, audio/haptics toggles)
- Progression (credits, upgrade levels, ship unlocks)
- Campaign progress (stage clears, per-stage best scores)
- Overall best score
- Tutorial completion flag
- Save version (for migration)

## Out of Scope

Backend, cloud save, accounts, multiplayer, ads, analytics, achievements, online leaderboards, daily rewards, endless mode, controller support.

## See Also

- `docs/RELEASE_CHECKLIST.md` - Pre-submission checklist
- `docs/STORE_METADATA_TEMPLATE.md` - Store listing drafts
- `docs/PRIVACY_SUMMARY.md` - Privacy policy text
- `docs/QA_TEST_MATRIX.md` - Manual QA matrix
