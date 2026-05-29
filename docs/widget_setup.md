# iOS Widget Extension Setup Guide

To make the widget appear on the iOS home screen, you need to create a Widget Extension target in Xcode.
`flutter_wk` does not generate the widget UI for you. It provides the bridge for writing shared data and reloading WidgetKit timelines.

## Important

The Widget Extension target must be created manually in Xcode.
This cannot be done from the Flutter CLI.

## Step 1: Open the iOS workspace

```bash
cd example/ios
open Runner.xcworkspace
```

Open the `.xcworkspace` file, not the `.xcodeproj` file.

## Step 2: Create the Widget Extension target

1. In Xcode, choose File > New > Target.
2. Select iOS > Widget Extension.
3. Click Next.
4. Use Swift as the language.
5. Do not include a configuration intent.
6. Choose any extension name you want. For the example app, `FlutterWidget` is the reference name.
7. When Xcode asks whether to activate the new scheme, click Cancel.

## Step 3: Replace the Xcode template widget files

The `flutter_wk` example uses `example/ios/FlutterWidget/FlutterWidget.swift` as the reference widget implementation.

1. Find the folder for your new widget extension target in Xcode.
2. Delete the template widget Swift file created by Xcode.
3. Delete `AppIntent.swift`, `*Control.swift`, and `*LiveActivity.swift` if Xcode created them.
4. Add a main widget Swift file based on `example/ios/FlutterWidget/FlutterWidget.swift`.
5. Make sure that file belongs only to the widget extension target.

The widget extension owns the SwiftUI view and the timeline provider.

## Step 4: Configure App Groups

Both the main app target and the widget extension target must use the same App Group.

### Runner target

1. Select the Runner target.
2. Open Signing & Capabilities.
3. Add the App Groups capability.
4. Create or select an App Group, for example `group.com.example.widget`.

### Widget Extension target

1. Select the widget extension target.
2. Open Signing & Capabilities.
3. Add the App Groups capability.
4. Select the exact same App Group.

## Step 5: Set the deployment target

WidgetKit requires iOS 14.0 or newer at runtime.

1. Select the widget extension target.
2. Open the General tab.
3. Set the iOS deployment target to `14.0` or newer.

## Step 6: Check the extension Info.plist

The widget extension Info.plist must include the WidgetKit extension point:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.widgetkit-extension</string>
</dict>
```

## Step 7: Wire Flutter to the same App Group

On the Flutter side, write data to the same App Group that the widget extension reads.

```dart
const appGroup = 'group.com.example.widget';
const key = 'widgetData';

await WidgetKit.setItem<String>(key, '{"text":"Hello Widget"}', appGroup);
await WidgetKit.reloadAllTimelines();
```

The example app uses:

- App Group: `group.com.ziqq`
- Data key: `widgetData`
- Widget Swift file: `example/ios/FlutterWidget/FlutterWidget.swift`

## Step 8: Build and run

1. Build the widget extension target in Xcode.
2. Switch back to the Runner scheme.
3. Run the Flutter app.
4. Add the widget from the iOS home screen.

## Data flow to verify

1. Flutter writes a value with `WidgetKit.setItem`.
2. Flutter calls `WidgetKit.reloadAllTimelines()` or `WidgetKit.reloadTimelines(...)`.
3. The widget extension reads from `UserDefaults(suiteName: appGroup)`.
4. The widget decodes the stored value and renders it.

## Common mistakes

- The app target and widget extension target use different App Group IDs.
- The widget Swift file is not added to the widget extension target.
- The widget extension is still using Xcode template files.
- The widget reads a different key than the Flutter app writes.
- Timelines are not reloaded after writing new data.