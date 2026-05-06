---
name: android-native
description: >
  Build and run the Android app on an emulator or physical device. Use when the user asks
  to build, compile, run, launch, or deploy the Android app, or mentions the APK,
  Gradle, emulator, device, or native-run, even if they don't explicitly say "android-native".
---

# Android Native

## Build

Run `./gradlew assembleDebug` to build the debug APK.

## Running on Emulator or Connected Device

Use `npx native-run` to run the app on an emulator or a physically connected device. Call `npx native-run android --list` to identify available targets (both emulators and connected devices will appear). If there is more than one option, ask the user which one to use.

Example:
```bash
./gradlew assembleDebug && npx native-run android --app app/build/outputs/apk/debug/app-debug.apk --target Pixel_10_Pro
```

## Running on a Physical Device

Ensure USB debugging is enabled on the device (Settings → Developer Options → USB Debugging) and the device is connected via USB. Verify it is detected with:

```bash
adb devices
```

Then build and deploy:

```bash
./gradlew assembleDebug && adb install app/build/outputs/apk/debug/app-debug.apk
```

Or use `native-run` if the device appears in `npx native-run android --list`:

```bash
./gradlew assembleDebug && npx native-run android --app app/build/outputs/apk/debug/app-debug.apk --target <DeviceID>
```

## Gotchas

- If `adb devices` shows the device as `unauthorized`, check the device screen and accept the USB debugging prompt.
- If the device is not listed at all, try a different USB cable or port, and confirm USB debugging is enabled.
- Always run `npx native-run android --list` or `adb devices` first — do not guess device IDs.
