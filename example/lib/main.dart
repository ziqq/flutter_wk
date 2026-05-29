import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev show log;

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter_wk/flutter_wk.dart';
import 'package:flutter_wk_example/flutter_widget_data.dart';

void main() => runZonedGuarded<void>(
  () => runApp(const App()),
  (e, s) => dev.log('Top level exception: $e\n$s'),
);

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  static const String title = 'iOS Widget Showcase';
  static const String appGroup = 'group.com.ziqq';
  static const String ofKind = 'widgetData';

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: title, home: _Home());
}

/// Home widget.
class _Home extends StatefulWidget {
  const _Home({
    super.key, // ignore: unused_element_parameter
  });

  @override
  __HomeState createState() => __HomeState();
}

/// State for [Home] widget.
class __HomeState extends State<_Home> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    final data = jsonEncode(FlutterWidgetData(_textController.text));
    await WidgetKit.setItem<String>(App.ofKind, data, App.appGroup);
    await WidgetKit.reloadAllTimelines();
  }

  Future<void> _onRemove() async {
    await WidgetKit.removeItem(App.ofKind, App.appGroup);
    await WidgetKit.reloadAllTimelines();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(App.title)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Enter a text for the widget'),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: TextField(
              key: const Key('widget-data-field'),
              controller: _textController,
            ),
          ),
          CupertinoButton(
            key: const Key('update-widget-button'),
            onPressed: _onUpdate,
            child: const Text('Update Widget'),
          ),
          CupertinoButton(
            key: const Key('remove-widget-data-button'),
            onPressed: _onRemove,
            child: const Text('Remove Widget Data'),
          ),
        ],
      ),
    ),
  );
}
