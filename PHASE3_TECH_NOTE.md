# Phase 3 Technical Note

## Current State (End of Phase 2)

Phase 2 delivers a replayable offline progression build with:
- 3 ships, 4 global upgrades (5 levels each), 3 difficulty tiers
- Persistent soft currency, ship unlock/select, upgrade purchase
- Run summary with reward breakdown
- Save versioning (version 2)
- 115 automated tests

## Recommended Phase 3 Directions

### Multiple Stages / Campaign
- Add a `StageDefinition` model with stage ID, wave timeline, background theme, boss config
- Create a stage selection screen (map or list)
- `SpawnTimeline` already supports parameterized wave generation; extend with per-stage templates
- Add stage completion tracking to `ProgressionRepository`

### Achievements System
- Add `AchievementDefinition` (id, condition, reward) and `AchievementRepository`
- Track conditions via game events (total kills, victories, ships unlocked, etc.)
- Wire into `RunSummaryScreen` to show newly unlocked achievements

### Audio Pipeline
- Replace `NoopAudioService` with `FlameAudioService` wrapping `flame_audio`
- Add BGM tracks and SFX assets to `assets/audio/`
- Trigger points already identified: fire, hit, enemy death, boss phase, victory, game over

### Cloud Save
- `KeyValueStore` abstraction makes this straightforward
- Implement a `CloudKeyValueStore` that syncs with a backend
- `SaveMigration` already handles version transitions

### Additional Ships / Weapons
- `ShipCatalog` and `ShipDefinition` are data-driven; add entries
- `ShipVisualStyle` enum can be extended with new render methods
- For multiple weapons: add `WeaponType` enum to `ShipDefinition`, create weapon-specific `PlayerWeapon` subclasses

### Monetization Prep
- `EconomyService` placeholder exists
- Add premium currency alongside credits
- Ship unlock costs can dual-price (credits or premium)

## Architecture Notes

- All balance values are in `game_balance.dart` and domain config classes
- Difficulty system is fully data-driven via `DifficultyConfig`
- Stat resolution pipeline (`ResolvedShipStats`) cleanly separates base stats, upgrades, and runtime modifiers
- Save migration pattern supports incremental schema evolution
- All persistence behind repository interfaces; no raw SharedPreferences in UI/game code
