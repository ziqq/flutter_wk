<!-- <h1 align="center">flutter_wk</h1>

<p align="center">
    <img alt="flutter" src="./.github/assets/flutter.png" width="96">
    <img alt="widgetkit" src="./.github/assets/widgetkit.png" width="96">
</p> -->

# flutter_wk

<div>
  <strong><a href="https://flutter.dev/">Flutter</a> Library for the iOS <a href="https://developer.apple.com/documentation/widgetkit/">WidgetKit framework</a> and Widget Communication</strong>
</div>


## Description

This library allows you to call essential methods from the iOS "WidgetKit Framework", which are needed when developing a widget. For example updating the widget timelines. It is also possible to communicate with the widget via <a href="https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups">App Groups</a>/<a href="https://developer.apple.com/documentation/foundation/userdefaults">UserDefaults</a>.

To be on the safe side: This library exposes API functionality of <a href="https://developer.apple.com/documentation/widgetkit/">WidgetKit</a>. The widgets themselves must be developed natively in SwiftUI.


## Installation

Add flutter_wk as a <a href="https://flutter.dev/docs/development/packages-and-plugins/using-packages">dependency in your pubspec.yaml</a> file.

Then run `flutter pub get`.


## Example

```dart
import 'package:flutter_wk/flutter_wk.dart';

const appGroup = 'group.com.example.widget';

// Reload widget timelines.
await WidgetKit.reload();
await WidgetKit.reloadOfKind('example_widget');

// Communicate with the widget through an App Group.
await WidgetKit.write<String>('testString', 'Hello World', appGroup);
final value = await WidgetKit.read<String>('testString', appGroup);
await WidgetKit.remove('testString', appGroup);
```

### iOS setup notes

- Widgets still need to be implemented natively in SwiftUI.
- Configure the same App Group for the app target and the widget extension.
- The iOS package supports Swift Package Manager and CocoaPods.
- The plugin's iOS deployment target is iOS 13.0. WidgetKit APIs require iOS 14.0 or newer at runtime.

### Error handling

- `WidgetKit.read`, `WidgetKit.write`, and `WidgetKit.remove` throw a `PlatformException` with code `missing_app_group` when `appGroup` is empty.
- The same methods throw a `PlatformException` with code `invalid_app_group` when the provided App Group is not configured for the app.
- A missing key still returns `null`; only App Group configuration problems are surfaced as errors.

### Documentation

- [Architecture guide](docs/architecture.md)
- [Roadmap](docs/roadmap.md)
- [Widget setup guide](docs/widget_setup.md)
- [Widget troubleshooting guide](docs/widget_troubleshooting.md)


## Methods

#### `Future<void> WidgetKit.reload()`

Reloads the timelines for all configured widgets belonging to the containing app.

#### `Future<void> WidgetKit.reloadOfKind(String kind)`

Reloads the timelines for all widgets of a particular kind.

#### `Future<T?> WidgetKit.write<T>(String key, Object? value, String appGroup)`

Writes Key-Value to <a href="https://developer.apple.com/documentation/foundation/userdefaults">UserDefaults</a> database.

Throws a `PlatformException` if the App Group is empty or invalid.

#### `Future<T?> WidgetKit.read<T>(String key, String appGroup)`

Reads Value from <a href="https://developer.apple.com/documentation/foundation/userdefaults">UserDefaults</a> database.

Throws a `PlatformException` if the App Group is empty or invalid.

#### `Future<bool> WidgetKit.remove(String key, String appGroup)`

Removes Value for Key from <a href="https://developer.apple.com/documentation/foundation/userdefaults">UserDefaults</a> database.

Throws a `PlatformException` if the App Group is empty or invalid.


## Changelog
Refer to the [Changelog](https://github.com/ziqq/flutter_wk/blob/main/CHANGELOG.md) to get all release notes.


## Maintainers
[Anton Ustinoff (ziqq)](https://github.com/ziqq)


## License
[MIT](https://github.com/ziqq/flutter_wk/blob/main/LICENSE)


## Funding
If you want to support the development of our library, there are several ways you can do it:

- [Buy me a coffee](https://www.buymeacoffee.com/ziqq)
- [Subscribe through Boosty](https://boosty.to/ziqq)


## Coverage
<img  src="https://codecov.io/gh/ziqq/flutter_wk/graphs/sunburst.svg?token=SIXKP5EDZK"  width="375">
