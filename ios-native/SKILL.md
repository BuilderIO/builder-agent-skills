---
name: ios-native
description: >
  Build and run the iOS app on a simulator or device. Use when the user asks
  to build, compile, run, launch, or deploy the iOS app, or mentions Xcode,
  xcodebuild, xcrun, the IPA, simulator, or native-run, even if they don't
  explicitly say "ios-native".
---

# iOS Native

## Build

Use `xcodebuild` to build the app. First, identify the scheme and workspace/project:

```bash
# List available schemes
xcodebuild -list
```

Build for simulator:

```bash
xcodebuild -scheme <SchemeName> -sdk iphonesimulator -configuration Debug -derivedDataPath build build
```

## Running on Simulator (preferred)

Use `npx native-run` to launch the app on an iOS simulator. First list available targets:

```bash
npx native-run ios --list
```

If there is more than one option, ask the user which one to use.

Then build and run:

```bash
xcodebuild -scheme <SchemeName> -sdk iphonesimulator -configuration Debug -derivedDataPath build build && npx native-run ios --app build/Build/Products/Debug-iphonesimulator/<AppName>.app --target <SimulatorUDID>
```

## Running on a Physical Device

Use `xcodebuild` with `-sdk iphoneos` and deploy via `xcrun`:

```bash
xcodebuild -scheme <SchemeName> -sdk iphoneos -configuration Debug -derivedDataPath build build
xcrun devicectl device install app --device <DeviceUDID> build/Build/Products/Debug-iphoneos/<AppName>.app
```

## Finding the App Bundle Path

After a successful build, the `.app` bundle is located at:

```
build/Build/Products/Debug-iphonesimulator/<AppName>.app   # simulator
build/Build/Products/Debug-iphoneos/<AppName>.app           # device
```

## Gotchas

- Always run `xcodebuild -list` first to get the correct scheme name — do not guess it.
- If the project uses a `.xcworkspace` (e.g. CocoaPods), pass `-workspace <Name>.xcworkspace` instead of `-project`.
- Use `npx native-run ios --list` to get the exact simulator UDID for the `--target` flag.
- Code signing is not required for simulator builds; for device builds, a valid provisioning profile and team ID are needed. If signing fails, inform the user.
- If `xcodebuild` is not found, Xcode Command Line Tools may not be installed (`xcode-select --install`).

## Shell command formatting

Always write commands on a single line — no backslash line continuations. The command ACL uses glob patterns without dotAll, so embedded newlines break matching for commands like `xcodebuild *`. For long output, pipe to `tail`/`head` or write to a file.
