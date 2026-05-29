import 'package:flutter/services.dart';

/// {@template flutter_wk}
/// Flutter plugin for iOS Widgets Extensions.
/// Integrate a Widget into your App.
/// {@endtemplate}
class WidgetKit {
  /// {@macro flutter_wk}
  const WidgetKit._();

  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('ziqq.github/flutter_wk');

  /// Reloads all timelines for all widgets.
  static Future<void> reload() => _channel.invokeMethod<void>('reload');

  /// Reloads timelines for widgets of a specific kind.
  static Future<void> reloadOfKind(String kind) => _channel.invokeMethod<void>(
    'reloadOfKind',
    <String, Object?>{'ofKind': kind},
  );

  /// Reads an item from the shared app group storage.
  static Future<T?> read<T>(String key, String appGroup) =>
      _channel.invokeMethod<T>('read', <String, Object?>{
        'key': key,
        'appGroup': appGroup,
      });

  /// Writes an item to the shared app group storage.
  static Future<T?> write<T>(String key, Object? value, String appGroup) =>
      _channel.invokeMethod<T>('write', <String, Object?>{
        'key': key,
        'value': value,
        'appGroup': appGroup,
      });

  /// Removes an item from the shared app group storage.
  static Future<bool> remove(String key, String appGroup) async =>
      await _channel.invokeMethod<bool>('remove', <String, Object?>{
        'key': key,
        'appGroup': appGroup,
      }) ??
      false;
}
