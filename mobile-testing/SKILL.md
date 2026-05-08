---
name: mobile-testing
description: >
  Install Maestro, run end-to-end tests, and create new test flows for the
  iOS and Android apps in this project. Use when the user asks to test the
  mobile apps, verify a feature on iOS or Android, set up Maestro, run a
  smoke test, write a new flow, or wants automated UI feedback after
  implementing mobile functionality, even if they don't say "Maestro".
---

# Mobile Testing (Maestro for iOS + Android)

Maestro drives the iOS Simulator and Android Emulator with simple YAML
flows. Use it to verify functionality after changes to `ios-app/` or
`android-app/`.

## Quick Start

1. Verify `builder.config.json` exists in the repo root with the required `allowedCommands` (see "Verify builder.config.json" below); create or update it if missing.
2. Confirm Maestro is installed (`maestro --version`); if not, install it.
3. Build and launch the relevant app on a simulator/emulator.
4. Run an existing flow from `maestro/` or create one for the new feature.
5. Report pass/fail plus screenshot/log paths back to the user.

## Verify builder.config.json

Before running any Maestro commands, ensure `builder.config.json` exists in the repository root and contains the following `allowedCommands` list. Without these entries the required shell commands (`maestro`, `xcrun`, `xcodebuild`, `./gradlew`, `adb`, etc.) will be blocked by ACL policy.

```json
{
  "allowedCommands": [
    "npm *",
    "pnpm *",
    "yarn *",
    "yarn",
    "bun *",
    "bun",
    "gh *",
    "wc *",
    "gradle *",
    "gradle",
    "rg *",
    "./gradlew *",
    "./gradlew",
    "adb *",
    "adb",
    "vp *",
    "vp",
    "git *",
    "export *",
    "rails *",
    "gem *",
    "bundle *",
    "rake *",
    "echo *",
    "cd *",
    "find *",
    "ls *",
    "rm *",
    "cp *",
    "mv *",
    "pwd",
    "curl *",
    "npx tsc *",
    "head *",
    "lsof *",
    "kill *",
    "ps *",
    "tr *",
    "awk *",
    "cat *",
    "grep *",
    "sed *",
    "tail *",
    "touch *",
    "mkdir *",
    "tee *",
    "true",
    "uniq *",
    "test *",
    "false",
    "npx *",
    "sort *",
    "env",
    "dirname",
    "basename *",
    "realpath *",
    "readlink *",
    "stat *",
    "file *",
    "diff *",
    "xargs *",
    "chmod *",
    "which *",
    "whoami",
    "uname *",
    "uname",
    "date",
    "date *",
    "printenv *",
    "sleep *",
    "netlify *",
    "node *",
    "tsx *",
    "builderio *",
    "builder *",
    "open *",
    "xcrun *",
    "xcodebuild *",
    "xcode-select *",
    "xed *",
    "agvtool *",
    "maestro *",
    "maestro"
  ]
}
```

If the file is missing, create it. If it exists but lacks any of the entries above, merge them in without removing existing allowed commands.

## 1. Install Maestro

Run only if `maestro --version` fails.

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
export PATH="$PATH:$HOME/.maestro/bin"
maestro --version
```

Platform prerequisites:
- iOS: Xcode + at least one iOS Simulator runtime.
- Android: Android SDK, an emulator AVD, `adb` on PATH.

## 2. Build the Apps

iOS (simulator build):
```bash
cd ios-app
xcodebuild -project movie-rater.xcodeproj \
  -scheme movie-rater \
  -sdk iphonesimulator \
  -configuration Debug \
  -derivedDataPath build
```
Resulting `.app`: `ios-app/build/Build/Products/Debug-iphonesimulator/movie-rater.app`

Android (debug APK):
```bash
cd android-app
./gradlew :app:assembleDebug
```
Resulting `.apk`: `android-app/app/build/outputs/apk/debug/app-debug.apk`

## 3. Boot a Simulator/Emulator and Install

iOS:
```bash
xcrun simctl boot "iPhone 15" || true
open -a Simulator
xcrun simctl install booted <path-to>.app
```

Android:
```bash
emulator -list-avds
emulator -avd <AvdName> &
adb wait-for-device
adb install -r <path-to>.apk
```

## 4. Run Tests

```bash
maestro test maestro/ios/smoke.yaml
maestro test maestro/android/smoke.yaml
maestro test maestro/                   # run all flows
```

Useful flags:
- `--format junit --output report.xml` for CI.
- `maestro studio` opens an interactive inspector (great for finding
  selectors when authoring a new flow).
- `maestro hierarchy` dumps the current screen's view tree.

## 5. Create a New Test Flow

Directory layout to follow:
```
maestro/
  ios/        # iOS-specific entry flows
  android/    # Android-specific entry flows
  shared/     # reusable sub-flows
```

Minimum flow shape:
```yaml
appId: com.example.movierater   # iOS bundle id or Android package
---
- launchApp:
    clearState: true
- assertVisible: "Movies"
- tapOn:
    id: "movie-card-title"
- assertVisible: "Details"
```

Authoring steps:
1. Open `maestro studio` against a running app to discover selectors.
2. Prefer `id:` selectors backed by stable accessibility identifiers.
3. If identifiers are missing, add them in app code:
   - SwiftUI: `.accessibilityIdentifier("movie-card-title")`
   - Android Views: `android:contentDescription` or resource id
   - Jetpack Compose: `Modifier.testTag("movie-card-title")` with
     `semantics { testTagsAsResourceId = true }`
4. Keep one user journey per flow file; extract shared steps to
   `maestro/shared/` and `runFlow:` them.
5. Re-run the flow until it passes deterministically.

## 6. Reporting Back

After running tests, surface to the user:
- The flow file(s) executed.
- Pass/fail summary and the failing step if any.
- Paths to screenshots, recordings, and `~/.maestro/tests/<run>/` logs.
- Any code changes made (e.g., added accessibility identifiers).

## Gotchas

- `appId` differs per platform — use the iOS bundle id in `maestro/ios/`
  flows and the Android package name in `maestro/android/` flows.
- The app must already be installed on the booted simulator/emulator
  before `maestro test` runs; Maestro does not build apps.
- Tests that rely on visible text break when copy changes; prefer
  `id:` selectors with accessibility identifiers.
- Compose `testTag` is invisible to Maestro unless
  `testTagsAsResourceId = true` is set on the semantics root.
- Only one iOS Simulator can be "booted" target at a time; if commands
  hit the wrong device, shut others down with `xcrun simctl shutdown all`.
- Android emulator boot is slow; always `adb wait-for-device` before
  installing or testing.
- Flaky network calls cause flaky tests — seed deterministic data or
  mock the network in debug builds rather than retrying.
- Don't introduce a custom back button in SwiftUI just to make a test
  easier; it breaks the swipe-back gesture. Fix the selector instead.
