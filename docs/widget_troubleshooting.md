# Widget Troubleshooting Guide

If the widget is not appearing in the Add Widget screen or it appears without data, use this checklist.

## Quick checklist

- The widget extension target exists in Xcode.
- The widget extension builds successfully.
- Runner and the widget extension use the exact same App Group.
- Flutter writes data to the same key the widget reads.
- Flutter reloads WidgetKit timelines after writing data.
- The widget extension deployment target is iOS 14.0 or newer.

## 1. Verify the widget extension builds

In Xcode:

1. Select the widget extension scheme.
2. Run Product > Build.
3. Fix all compile errors before testing the Flutter app.

Typical failures:

- `No such module 'WidgetKit'`: the deployment target is too low.
- `Use of unresolved identifier`: the widget Swift file is missing from the extension target.
- App Group or entitlement errors: the extension target is not configured correctly.

## 2. Verify the App Group

Runner and the widget extension must use the same App Group string.

Check all of these places:

- Runner target Signing & Capabilities
- Widget extension target Signing & Capabilities
- Flutter code calling `WidgetKit.setItem` and `WidgetKit.getItem`
- Swift widget code calling `UserDefaults(suiteName: ...)`

For the example app, the App Group is `group.com.ziqq`.

## 3. Verify the widget files

Your widget extension should contain:

- a main widget Swift file with `@main`
- timeline provider logic
- SwiftUI view code
- an Info.plist with `com.apple.widgetkit-extension`
- a widget extension entitlements file

Remove leftover Xcode template files if you replaced them.

## 4. Verify Flutter writes the expected value

`flutter_wk` only writes and reads shared values. It does not define your widget model automatically.

Check that Flutter writes:

- the expected App Group
- the expected key
- the expected payload shape

Typical example:

```dart
await WidgetKit.setItem<String>('widgetData', '{"text":"Hello Widget"}', appGroup);
await WidgetKit.reloadAllTimelines();
```

## 5. Verify the widget reads the same key

In Swift, confirm the widget uses the same App Group and the same key.

For the example widget this means:

- `UserDefaults(suiteName: "group.com.ziqq")`
- reading the `widgetData` key

If the widget expects JSON, make sure it decodes the stored string or object in the same shape Flutter wrote.

## 6. Verify timeline reloads

If the widget builds but does not refresh:

- call `WidgetKit.reloadAllTimelines()` after writing data
- or call `WidgetKit.reloadTimelines('YourWidgetKind')` with the correct widget kind
- make sure the widget kind matches the one registered by the widget extension

## 7. Clean and rebuild

If configuration changed recently, rebuild from a clean state.

```bash
cd example
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter pub get
flutter run
```

## 8. Check the generated app bundle

If the widget does not appear in the system picker at all:

1. Build the app in Xcode.
2. Confirm the widget extension is embedded in the app.
3. Confirm the widget extension has valid signing and entitlements.

## Common failure patterns

### Widget not visible in Add Widget

- The widget extension target does not build.
- The extension is not embedded into the app bundle.
- The extension Info.plist is missing the WidgetKit extension point.
- The widget file is still the wrong Xcode template.

### Widget appears but shows no data

- Flutter writes to a different App Group than Swift reads.
- Flutter writes a different key than Swift reads.
- Flutter writes JSON but Swift expects another payload shape.
- Timelines are not reloaded after writing data.

### App Group mismatch

Every location must use the exact same App Group string.
One character difference is enough to break storage access.

## Helpful checks

```bash
# Check Runner entitlements
plutil -p example/ios/Runner/Runner.entitlements

# Check widget extension entitlements
plutil -p example/ios/FlutterWidgetExtension.entitlements

# Find built widget extensions
find example/build/ios -name "*.appex" -type d
```