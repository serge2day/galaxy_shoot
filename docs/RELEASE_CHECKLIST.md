# Release Checklist

## Build Verification
- [ ] `flutter analyze` passes with no issues
- [ ] `flutter test` passes all tests
- [ ] `flutter build apk --release` succeeds
- [ ] `flutter build ios --release --no-codesign` succeeds
- [ ] App runs on Android device/emulator in release mode
- [ ] App runs on iOS device/simulator in release mode

## App Configuration
- [ ] App display name set correctly in AndroidManifest.xml and Info.plist
- [ ] Bundle ID / package name configured
- [ ] Version and build number set in pubspec.yaml
- [ ] Portrait orientation enforced
- [ ] Debug banner disabled
- [ ] No unnecessary permissions in manifests

## Content Verification
- [ ] All 3 stages playable start to finish
- [ ] All 3 bosses defeatable
- [ ] All 3 ships unlockable and selectable
- [ ] All 4 upgrade lines purchasable to max level
- [ ] All 3 difficulty tiers work correctly
- [ ] All 3 pickup types function
- [ ] Tutorial shows on first launch
- [ ] Credits earned and persisted correctly
- [ ] Stage unlock progression works (1 -> 2 -> 3)

## Assets (Replace Before Submission)
- [ ] App icon (1024x1024 PNG) placed in platform folders
- [ ] Splash screen configured or default is acceptable
- [ ] SFX files added to assets/ (optional - graceful fallback exists)
- [ ] BGM file added to assets/ (optional - graceful fallback exists)
- [ ] Store screenshots captured (5+ per platform)

## Store Preparation
- [ ] Store listing text drafted (see STORE_METADATA_TEMPLATE.md)
- [ ] Privacy policy text ready (see PRIVACY_SUMMARY.md)
- [ ] Content rating questionnaire completed
- [ ] Age rating: suitable for Everyone / 10+
- [ ] App category: Arcade / Action

## Final QA
- [ ] Complete QA_TEST_MATRIX.md manual checks
- [ ] No crashes during normal gameplay
- [ ] Pause/resume works correctly
- [ ] App lifecycle (background/foreground) handled
- [ ] Reset progress works and requires confirmation
