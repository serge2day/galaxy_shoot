# STARVANE

A portrait-mode mobile arcade space shooter built with Flutter and Flame. Features a 9-stage campaign, Endless Galaxy mode with procedural sector generation, 6 playable ships, in-run evolution system, and persistent offline progression.

## Game Overview

STARVANE is an arcade vertical shooter where players battle through alien waves, collect evolution cores to power up their ship, defeat bosses, and progress through an ever-expanding galaxy.

## Game Modes

### Campaign Mode
- 9 handcrafted stages across 3 sectors
- Sector 1 (Frontier, Patrol, Warden): Intro enemies, learning curve
- Sector 2 (Nebula, Storm, Abyss): Mixed enemy types, swarmers, carriers
- Sector 3 (Ember, Siege, Dark Core): Elite enemies, heavy combat
- Bosses at stages 3, 6, 9 (mini-bosses at 2, 5, 8)
- 3 difficulty tiers: Normal, Veteran, Expert

### Endless Galaxy Mode
- Procedurally generated infinite sectors
- 6 biome kits (Frontier Void → Core Abyss)
- 4-6 missions per sector with multi-mission carry-over
- 7 mission types: Assault, Swarm Rush, Elite Hunt, Survival, Hazard, Miniboss, Boss
- Sector modifiers: Aggressive Swarm, Heavy Armor, Storm Front, Volatile Core, Elite Patrol, Weapon Surge
- Difficulty scales infinitely with sector depth

## Ships (6 total)

| Ship | Style | HP | Speed | Damage | Unlock Cost |
|------|-------|-----|-------|--------|-------------|
| Vanguard | Balanced | 4 | 500 | 1 | Free |
| Striker | Fast fire | 4 | 580 | 1 | 1500 CR |
| Guardian | Tough | 7 | 420 | 1 | 2000 CR |
| Ravager | Heavy hitter | 5 | 460 | 2 | 2500 CR |
| Phantom | Agile | 3 | 650 | 1 | 1800 CR |
| Titan | Tank | 9 | 380 | 2 | 3500 CR |

## Enemy Families (5 types)

| Enemy | Role | HP | Speed |
|-------|------|-----|-------|
| Drone | Baseline | 2 | 120 |
| Interceptor | Fast/aggressive | 3 | 180 |
| Gunship | Heavy/tanky | 6 | 70 |
| Swarmer | Group pressure | 1 | 150 |
| Carrier | Spawns swarmers | 8 | 60 |

Elite variants: 2x HP, 1.3x size, guaranteed drops, 2x score.

## In-Run Evolution System

- Enemies drop evolution cores (20% base, 100% elites)
- 5 evolution levels with visible ship growth
- Weapon lanes: 1 → 2 → 2 → 3 → 3
- Damage multiplier scales 1.0x → 1.4x
- Ship visually scales 1.0x → 1.4x
- Overdrive mode: 5 seconds of boosted fire after max evolution
- Evolution drops one level on life loss
- Bomb system: collectible charges, screen-clear effect

## Pickups

| Pickup | Label | Effect |
|--------|-------|--------|
| Evolution Core | E | Advances evolution meter |
| Shield | S | Blocks one hit for 3 seconds |
| Heal | H | Restores HP to max |
| Bomb Charge | B | Adds bomb charge (max 3) |

## Progression & Economy

- Credits earned from enemy kills (3 CR each) and boss defeats (80 CR)
- Difficulty multiplier: Normal x1.0, Veteran x1.5, Expert x2.5
- 4 global upgrade lines (5 levels each): Max HP, Fire Rate, Bullet Damage, Movement Speed
- Ship unlocks persist locally
- Stage clears and best scores tracked per stage
- Endless mode: highest sector and per-ship records

## Audio System

- **SFX**: Native Android SoundPool via MethodChannel (low latency, no memory leaks)
- **Music**: FlameAudio.bgm for looping tracks (menu, battle, boss)
- Per-sound volume: fire 10%, enemy_hit 25%, enemy_death 35%, others 100%
- Settings: music/SFX toggles + volume sliders, persisted
- Pauses on app background, resumes on foreground

## Architecture

```
lib/
  main.dart                          # Entry, orientation, migration, audio init
  app/
    app.dart                         # MaterialApp with lifecycle observer
    game_page.dart                   # Campaign game flow
    endless_game_page.dart           # Endless mode game flow
    providers.dart                   # All Riverpod providers
    routes.dart                      # Named routes
    theme/app_theme.dart             # Dark sci-fi theme
  core/
    config/
      app_config.dart                # App metadata
      game_balance.dart              # Player/enemy/boss tuning values
      game_constants.dart            # Storage keys
    persistence/
      key_value_store.dart           # Storage abstraction
      shared_prefs_store.dart        # SharedPreferences implementation
      save_migration.dart            # Schema versioning (v1→v5)
    services/
      audio_service.dart             # Audio interface
      flame_audio_service.dart       # Native SoundPool SFX + FlameAudio BGM
      game_audio.dart                # Global audio singleton
      haptics_service.dart           # Haptics interface
      flutter_haptics_service.dart   # Real haptic feedback
      game_haptics.dart              # Global haptics singleton
    utils/
      responsive.dart                # Screen-size scaling utility
      math_utils.dart                # Random helpers
      extensions.dart                # Vector2 extensions
  features/
    home/                            # Home screen with background image
    settings/                        # Fire mode, audio/haptics toggles, volume sliders, reset
    about/                           # Privacy, version, contact
    high_score/                      # Overall best score
    session/                         # RunResult model
    hangar/                          # Ships, stats, upgrades, ship catalog
    progression/                     # Wallet, difficulty, rewards, upgrade definitions
    campaign/                        # Stage progress, stage select
    tutorial/                        # First-run tutorial
    endless/
      domain/                        # Biome, sector, mission, modifier, wave definitions
      data/                          # Local endless repository
      generation/                    # Sector, mission, wave generators
      presentation/                  # Endless entry screen
  game/
    galaxy_game.dart                 # FlameGame: state, evolution, bomb, stage
    systems/
      evolution_system.dart          # 5-level evolution + overdrive
      bomb_system.dart               # Screen-clear bomb charges
    world/
      galaxy_world.dart              # World component, spawning, obstacles
      formation_spawner.dart         # Grid/V/diamond/arc/line formations
      stages/                        # 9 stage definitions + registry
    components/
      background/                    # Starfield + space background (nebulae, planets)
      player/                        # PlayerShip (6 styles, sprite support), weapon
      enemies/                       # EnemyShip (5 types), EnemyType, weapon
      boss/                          # BossShip (3 phases), weapon, health bar
      pickups/                       # PickupItem, PickupType
      effects/                       # Explosion, HitFlash, MuzzleFlash, ScreenShake
      obstacles/                     # Asteroid, SpaceMine, SatelliteDebris, SpaceDebris
      projectiles/                   # PlayerBullet, EnemyBullet
      ui/                            # HUD, FireButton
  future/                            # Placeholder interfaces
android/
  .../MainActivity.kt               # Native SoundPool for SFX
assets/
  images/                            # Home bg, app icon, ship sprites
  audio/                             # 12 SFX + 3 BGM tracks
docs/                                # Release docs
```

## Dependencies

| Package | Purpose |
|---------|---------|
| flame | 2D game engine |
| flame_audio | BGM playback |
| flutter_riverpod | State management / DI |
| shared_preferences | Local persistence |
| flutter_lints | Lint rules |
| flutter_launcher_icons | App icon generation |

## How to Run

```bash
flutter pub get
flutter run
```

## How to Test

```bash
flutter analyze
flutter test
```

172 automated tests covering: unit, widget, and game logic.

## Build Release

```bash
flutter build apk --release         # Android
flutter build ios --release --no-codesign  # iOS
```

## Data Stored Locally

- Game settings (fire mode, audio/haptics toggles, volumes)
- Progression (credits, upgrade levels, ship unlocks)
- Campaign progress (stage clears, per-stage best scores)
- Endless progress (highest sector, per-ship records)
- Overall best score, tutorial completion, save version

## Privacy

Fully offline. No data collected, transmitted, or shared. No accounts, no cloud sync, no analytics. All data stored locally. Reset available in Settings.
