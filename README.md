# MOO-VE IT! — The Nitrogen Crisis

Exergame MVP: walk around the real world to find cows (💰) and nitrogen
clouds (☁️, shake your phone to clear them) before the 5-minute season ends.
Uses GPS, accelerometer, and the camera — see the plan at
`/home/bart/.claude/plans/case-the-nitrogen-crisis-cuddly-waterfall.md`.

## First-time setup (this sandbox has no Flutter SDK — run these on your machine)

```bash
flutter create . --project-name cow_game --org com.example
flutter pub get
```

`flutter create .` scaffolds `android/` and `ios/` without touching the
`lib/`, `test/`, or `pubspec.yaml` already in this repo.

### Add permissions

**`android/app/src/main/AndroidManifest.xml`** — inside `<manifest>`, above `<application>`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="true"/>
```

**`ios/Runner/Info.plist`** — inside the top-level `<dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>MOO-VE IT! uses your location to place cows and nitrogen clouds around you.</string>
<key>NSCameraUsageDescription</key>
<string>MOO-VE IT! uses the camera for the cow-catching mini-game.</string>
```

## Run

```bash
flutter run
```

GPS, camera, and shake detection only work on a real device (most emulators
fake or lack these sensors) — install on a phone to actually test the game
loop.

## Verify

```bash
flutter analyze
flutter test
flutter build apk --debug   # or: flutter build ios --debug --no-codesign
```
