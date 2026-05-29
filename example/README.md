# flutter_wk_example

This example demonstrates the intended `flutter_wk` integration flow:

- Flutter writes widget data into shared App Group storage.
- Flutter triggers WidgetKit timeline reloads.
- The native SwiftUI widget extension reads the same shared data and renders it.

## What the example includes

- Flutter app UI in `lib/main.dart`
- Example payload model in `lib/flutter_widget_data.dart`
- Native widget extension in `ios/FlutterWidget/FlutterWidget.swift`
- Widget interaction tests in `test/widget_test.dart`

## Example contract

The example app and widget extension share these values:

- App Group: `group.com.ziqq`
- Storage key: `widgetData`
- Widget kind: `FlutterWidget`

If you adapt this example for your own app, update all three places together.

## Running the example

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Make sure the Runner target and widget extension use the same App Group.
3. Run the Flutter app.
4. Add the widget to the iOS home screen.
5. Update or remove widget data from the Flutter UI.

## Notes

- The widget UI is implemented natively in SwiftUI.
- `flutter_wk` only provides the bridge for storage and timeline reloads.
- If the widget does not appear or does not refresh, see `../docs/widget_setup.md` and `../docs/widget_troubleshooting.md`.

## Flutter API used in the example

- `WidgetKit.write`
- `WidgetKit.remove`
- `WidgetKit.reload`
- `WidgetKit.reloadOfKind`
