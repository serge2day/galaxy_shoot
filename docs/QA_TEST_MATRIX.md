# QA Test Matrix

## Home Screen
- [ ] Title and version displayed
- [ ] Best score shows correctly
- [ ] Credits balance shows correctly
- [ ] Selected ship name shows correctly
- [ ] PLAY button navigates to tutorial (first run) then stage select
- [ ] HANGAR button navigates to hangar
- [ ] SETTINGS button navigates to settings
- [ ] ABOUT button navigates to about

## Tutorial
- [ ] Shows on first launch
- [ ] All pages display correctly
- [ ] NEXT advances pages
- [ ] SKIP completes tutorial
- [ ] Does not show again after completion
- [ ] Can be replayed from Settings

## Stage Select
- [ ] Stage 1 unlocked by default
- [ ] Stage 2 locked until Stage 1 cleared
- [ ] Stage 3 locked until Stage 2 cleared
- [ ] Locked stages are not tappable
- [ ] Per-stage best score displays correctly
- [ ] Clear marker shows for cleared stages
- [ ] Back navigates to home

## Difficulty Select
- [ ] Normal, Veteran, Expert displayed
- [ ] Reward multipliers shown
- [ ] Selecting a tier starts gameplay
- [ ] Back navigates to stage select

## Gameplay
- [ ] Ship spawns at correct position
- [ ] Drag movement works smoothly
- [ ] Ship stays within bounds
- [ ] Auto fire works in auto mode
- [ ] Fire button appears in manual mode
- [ ] Manual fire button works
- [ ] Enemies spawn in waves
- [ ] All 3 enemy types appear (per stage composition)
- [ ] Enemy bullets damage player
- [ ] Player bullets damage enemies
- [ ] Score increases on enemy kill
- [ ] Pickups drop from some enemies
- [ ] Weapon Boost increases weapon level
- [ ] Shield blocks one hit
- [ ] Heal restores HP
- [ ] Boss appears after waves complete
- [ ] Boss health bar displays
- [ ] Boss has 3 phases
- [ ] Victory on boss defeat
- [ ] Game over when lives exhausted
- [ ] Explosion effects on enemy death
- [ ] Hit flash on damage

## Pause
- [ ] Pause button pauses game
- [ ] Resume continues gameplay
- [ ] Restart resets the run
- [ ] Home returns to home screen
- [ ] App background triggers pause

## Results Screen
- [ ] Score displayed
- [ ] NEW BEST shown when applicable
- [ ] Credits earned displayed
- [ ] Reward breakdown shown
- [ ] Stage name displayed
- [ ] Ship name displayed
- [ ] Difficulty displayed
- [ ] PLAY AGAIN restarts same stage
- [ ] NEXT STAGE appears on victory (if next stage exists)
- [ ] HOME returns to home
- [ ] HANGAR navigates to hangar

## Hangar
- [ ] All 3 ships displayed
- [ ] Vanguard is free and unlocked by default
- [ ] Phantom costs 500 CR to unlock
- [ ] Titan costs 800 CR to unlock
- [ ] Unlock button disabled when insufficient credits
- [ ] Unlock deducts credits
- [ ] Selected ship shows ACTIVE badge
- [ ] SELECT button changes active ship
- [ ] All 4 upgrades displayed
- [ ] Upgrade costs increase per level
- [ ] MAX shown at level 5
- [ ] Credits balance updates immediately

## Settings
- [ ] Fire mode toggle (Auto/Manual) persists
- [ ] Music toggle persists
- [ ] Sound Effects toggle persists
- [ ] Haptics toggle persists
- [ ] REPLAY TUTORIAL button works
- [ ] RESET ALL PROGRESS shows confirmation
- [ ] Reset confirmation cancel preserves data
- [ ] Reset confirmation confirm wipes all progress
- [ ] After reset: credits=0, upgrades=0, ships reset, stages reset

## About
- [ ] Game title displayed
- [ ] Version displayed
- [ ] Privacy text present
- [ ] Contact info present

## Persistence
- [ ] Close and reopen: all progress preserved
- [ ] Force kill and reopen: all progress preserved
- [ ] Settings survive restart
- [ ] Credits survive restart
- [ ] Ship selection survives restart
- [ ] Stage clears survive restart

## Performance
- [ ] Smooth 60fps during normal gameplay
- [ ] No memory leaks after multiple runs
- [ ] No frame drops during boss fights
- [ ] No stuck states after rapid pause/resume
