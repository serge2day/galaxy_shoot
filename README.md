# Galaxy Shooter

A portrait-mode mobile arcade space shooter built with Flutter and Flame. Phase 1 delivers a polished vertical slice with scalable architecture for future expansion.

## Phase 1 Scope

- One player ship with drag-to-move controls
- One weapon type (forward-firing plasma)
- One regular enemy archetype with 3 movement patterns (straight, sine wave, diagonal)
- One scrolling level with 10 scripted enemy waves
- One boss encounter with 2 behavior phases
- Score system, health, and lives
- Game over and victory flows with restart
- Local high score persistence
- Settings screen with fire mode selection (Auto / Manual)
- Placeholder interfaces for future systems

## Architecture

```
lib/
  main.dart                    # App entry, orientation lock, provider setup
  app/
    app.dart                   # MaterialApp with theme and routes
    game_page.dart             # Flame GameWidget wrapper with overlays
    providers.dart             # Riverpod providers for settings, scores
    routes.dart                # Named route definitions
    theme/app_theme.dart       # Dark sci-fi theme
  core/
    config/
      app_config.dart          # App metadata
      game_balance.dart        # Centralized tuning values
      game_constants.dart      # Storage keys
    persistence/
      key_value_store.dart     # Storage abstraction
      shared_prefs_store.dart  # SharedPreferences implementation
    services/
      audio_service.dart       # Audio interface (placeholder)
      haptics_service.dart     # Haptics interface (placeholder)
      analytics_service.dart   # Analytics interface (placeholder)
      noop_*_service.dart      # No-op implementations
    utils/
      math_utils.dart          # Random helpers
      extensions.dart          # Vector2 extensions
  features/
    home/presentation/         # Home screen UI
    settings/                  # Settings domain, data, presentation
    high_score/                # High score domain and data
    session/domain/            # RunResult model
  game/
    galaxy_game.dart           # FlameGame subclass, game state management
    world/
      galaxy_world.dart        # World component, drag input, wave spawning
      spawn_timeline.dart      # Level script data
    components/
      background/              # Parallax starfield
      player/                  # Player ship + weapon
      enemies/                 # Enemy ship + weapon
      boss/                    # Boss ship + weapon + health bar
      projectiles/             # Player and enemy bullets
      ui/                      # HUD, fire button
  future/
    progression/               # ProgressionService placeholder
    economy/                   # EconomyService placeholder
    ships/                     # ShipCatalogService placeholder
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

Portrait orientation is enforced. The app targets iOS and Android.

## How to Test

```bash
flutter test
flutter analyze
```

Tests cover:
- **Unit**: Settings repo, high score repo, fire mode parsing, game settings model, run result model, spawn timeline, game balance values
- **Widget**: Home screen rendering, navigation, settings screen rendering and interaction
- **Game logic**: Boss phase values, player damage/lives logic

## Out of Scope (Phase 1)

These systems are intentionally not implemented beyond placeholder interfaces:

- Multiple ships, weapons, or enemy families
- Upgrades, currency, economy
- Mission map / stage selection
- Daily rewards, achievements
- Online leaderboards, cloud save
- Ads, monetization, analytics
- Account system
- Audio/haptics production
- Asset pipelines

## Extending for Future Phases

- **New weapons**: Add weapon classes implementing a weapon interface, wire into player ship
- **New enemies**: Extend `EnemyShip` or create new archetypes, add to spawn timeline
- **Multiple levels**: Create additional `SpawnTimeline` configurations, add level selection
- **Progression**: Replace `NoopProgressionService` with real implementation
- **Economy**: Replace `NoopEconomyService` with currency/shop logic
- **Audio**: Replace `NoopAudioService` with a real audio engine (e.g., flame_audio)
- **Ships**: Replace `NoopShipCatalogService` with ship unlock/selection
- **Settings**: Add new fields to `GameSettings` and extend the settings screen
- **Persistence**: Swap `SharedPrefsStore` for any backend behind the `KeyValueStore` interface
