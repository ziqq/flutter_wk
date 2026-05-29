import 'package:flutter/services.dart';

/// {@template flutter_wk}
/// Flutter plugin for iOS Widgets Extensions.
/// Integrate a Widget into your App.
/// {@endtemplate}
class WidgetKit {
  static const MethodChannel _channel = MethodChannel('ziqq.github/flutter_wk');

  /// Reloads all timelines for all widgets.
  static Future<void> reloadAllTimelines() =>
      _channel.invokeMethod<void>('reloadAllTimelines');

  /// Reloads timelines for widgets of a specific kind.
  static Future<void> reloadTimelines(String ofKind) =>
      _channel.invokeMethod<void>('reloadTimelines', <String, Object?>{
        'ofKind': ofKind,
      });

  /// Gets an item from the shared app group storage.
  static Future<T?> getItem<T>(String key, String appGroup) =>
      _channel.invokeMethod<T>('getItem', <String, Object?>{
        'key': key,
        'appGroup': appGroup,
      });

  /// Sets an item in the shared app group storage.
  static Future<T?> setItem<T>(String key, Object? value, String appGroup) =>
      _channel.invokeMethod<T>('setItem', <String, Object?>{
        'key': key,
        'value': value,
        'appGroup': appGroup,
      });

  /// Removes an item from the shared app group storage.
  static Future<bool> removeItem(String key, String appGroup) async =>
      await _channel.invokeMethod<bool>('removeItem', <String, Object?>{
        'key': key,
        'appGroup': appGroup,
      }) ??
      false;
}
