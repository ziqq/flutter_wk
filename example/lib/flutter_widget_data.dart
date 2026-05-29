import 'package:flutter/foundation.dart';

/// {@template flutter_widget_data}
/// A simple data class representing the data to be displayed in the widget.
/// {@endtemplate}
@immutable
class FlutterWidgetData {
  /// {@macro flutter_widget_data}
  const FlutterWidgetData(this.text);

  /// The text to be displayed in the widget.
  final String text;

  /// Creates a [FlutterWidgetData] instance from a JSON map.
  factory FlutterWidgetData.fromJson(Map<String, Object?> json) {
    if (json.isEmpty) throw ArgumentError('JSON is empty');
    if (json case <String, Object?>{'text': String text}) {
      return FlutterWidgetData(text);
    } else {
      throw FormatException(
        'Invalid JSON format: '
        'expected a map with a "text" key of type String',
      );
    }
  }

  Map<String, Object?> toJson() => {'text': text};

  @override
  String toString() => 'FlutterWidgetData{text: $text}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlutterWidgetData &&
          runtimeType == other.runtimeType &&
          text == other.text;

  @override
  int get hashCode => text.hashCode;
}
