import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wk_example/main.dart';

void main() {
  const channel = MethodChannel('ziqq.github/flutter_wk');
  final calls = <MethodCall>[];

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          switch (call.method) {
            case 'remove':
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('widget actions', () {
    testWidgets('updates widget data and reloads timelines', (tester) async {
      await tester.pumpWidget(const App());

      await tester.enterText(
        find.byKey(const Key('widget-data-field')),
        'Hello Widget',
      );
      await tester.tap(find.byKey(const Key('update-widget-button')));
      await tester.pump();

      expect(calls, hasLength(2));
      expect(calls[0].method, 'write');
      expect(calls[0].arguments, <String, Object?>{
        'key': 'widgetData',
        'value': jsonEncode(const {'text': 'Hello Widget'}),
        'appGroup': 'group.com.ziqq',
      });
      expect(calls[1].method, 'reload');
    });

    testWidgets('removes widget data and reloads timelines', (tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byKey(const Key('remove-widget-data-button')));
      await tester.pump();

      expect(calls, hasLength(2));
      expect(calls[0].method, 'remove');
      expect(calls[0].arguments, <String, Object?>{
        'key': 'widgetData',
        'appGroup': 'group.com.ziqq',
      });
      expect(calls[1].method, 'reloadOfKind');
      expect(calls[1].arguments, <String, Object?>{'ofKind': 'widgetData'});
    });
  });
}
