# Galaxy Shooter

A portrait-mode mobile arcade space shooter built with Flutter and Flame. Phase 2 adds persistent progression, ship selection, upgrades, difficulty tiers, and a real meta-loop on top of the Phase 1 foundation.

## Phase 2 Scope

**Gameplay:**
- Same core stage structure as Phase 1 with improved wave variety (14 waves with seeded variation)
- Three difficulty tiers: Normal, Veteran, Expert (affects enemy/boss HP, fire rate, rewards)
- Real pause menu with Resume, Restart, and Home

**Progression:**
- Persistent soft currency (credits) earned from gameplay
- Three playable ships with distinct stats and visuals (Vanguard, Phantom, Titan)
- Ship unlock/select flow in the Hangar
- Four global upgrade lines: Max HP, Fire Rate, Bullet Damage, Movement Speed (5 levels each)
- Run summary screen with score, rewards breakdown, and quick actions

**Persistence:**
- Local save data with versioning and Phase 1 migration support
- Persisted: wallet, unlocked ships, selected ship, upgrade levels, best score, fire mode

## Architecture

```
lib/
  main.dart                           # Entry, orientation, migration, providers
  app/
    app.dart                          # MaterialApp with theme and routes
    game_page.dart                    # Game lifecycle, difficulty select, pause, summary
    providers.dart                    # All Riverpod providers (settings, score, wallet, ships, upgrades)
    routes.dart                       # Named routes (home, settings, game, hangar)
    theme/app_theme.dart              # Dark sci-fi theme
  core/
    config/
      app_config.dart                 # App metadata
      game_balance.dart               # Centralized tuning values
      game_constants.dart             # Persistence keys
    persistence/
      key_value_store.dart            # Storage abstraction
      shared_prefs_store.dart         # SharedPreferences implementation
      save_migration.dart             # Versioned save migration
    services/                         # Audio, haptics, analytics (placeholder interfaces + no-ops)
    utils/                            # Math helpers, extensions
  features/
    home/presentation/                # Home screen (title, best score, credits, ship, CTA)
    settings/                         # Fire mode setting (domain, data, presentation)
    high_score/                       # Best score persistence (domain, data)
    session/domain/                   # RunResult model (score, outcome, kills, boss)
    hangar/
      domain/                         # ShipDefinition, ShipStats, ShipCatalog, ResolvedShipStats
      data/                           # LocalShipCatalogRepository
      presentation/                   # HangarScreen, ShipCard, UpgradePanel
    progression/
      domain/                         # CurrencyWallet, DifficultyTier, DifficultyConfig,
                                      # UpgradeDefinition, UpgradeState, RewardCalculator, etc.
      data/                           # LocalProgressionRepository
      presentation/                   # DifficultySelectScreen, RunSummaryScreen
  game/
    galaxy_game.dart                  # FlameGame: state, stats, difficulty, kill tracking
    world/
      galaxy_world.dart               # World component, spawning, drag input
      spawn_timeline.dart             # Seeded wave templates (14 waves + boss)
    components/
      background/                     # Parallax starfield
      player/                         # PlayerShip (3 visual styles), PlayerWeapon (configurable)
      enemies/                        # EnemyShip (difficulty-scaled), EnemyWeapon
      boss/                           # BossShip (difficulty-scaled), BossWeapon, BossHealthBar
      projectiles/                    # PlayerBullet, EnemyBullet
      ui/                             # HUD, FireButton
  future/                             # Placeholder interfaces (progression, economy, ships)
```

## Dependencies

| Package | Purpose |
|---------|---------|
| flame | 2D game engine |
| flutter_riverpod | State management / DI |
| shared_preferences | Local persistence |
| flutter_lints | Lint rules |

## How to Run

```bash
flutter pub get
flutter run
```

Portrait orientation is enforced. Targets iOS and Android.

## How to Test

```bash
flutter test
flutter analyze
```

115 tests covering:
- **Unit**: Wallet logic, reward calculation, ship catalog, upgrade rules/costs/max-level, difficulty modifiers, stat resolution pipeline, save migration, persistence for wallet/upgrades/ships, settings, high score, fire mode, game balance
- **Widget**: Home screen (credits, ship name, navigation), settings screen, hangar screen (ship cards, unlock/active states, upgrades section), difficulty selection screen
- **Game logic**: Boss phase values, difficulty scaling, player damage/lives, double-claim prevention, enemy/boss kill tracking

## Stat Resolution Pipeline

Final gameplay stats are computed from:
1. **Ship base stats** (ShipDefinition)
2. **Global upgrades** (UpgradeState applied via ResolvedShipStats)
3. **Difficulty modifiers** (applied at runtime in enemy/boss onLoad)

## Out of Scope (Phase 2)

- Multiple stages / campaign map
- Online leaderboards, cloud save
- Achievements, daily rewards
- More than 3 ships or 4 upgrade lines
- Multiple weapon classes
- Ads, monetization, analytics SDKs
- Audio/haptics production
- Account system, social features

## Extending for Future Phases

- **New ships**: Add entries to `ShipCatalog.ships`, add visual style enum + render method
- **New upgrades**: Add to `UpgradeType` enum and `UpgradeConfig.definitions`
- **New stages**: Create additional `SpawnTimeline` configurations, add stage selection
- **Multiple weapons**: Extend `PlayerWeapon` with weapon type system
- **Audio**: Replace `NoopAudioService` with real implementation
- **Cloud save**: Replace `KeyValueStore` with a cloud-backed implementation
- **Achievements**: Add achievement definitions and tracking service
