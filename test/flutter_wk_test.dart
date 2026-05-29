import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wk/flutter_wk.dart';

void main() {
  const MethodChannel channel = MethodChannel('ziqq.github/flutter_wk');
  final calls = <MethodCall>[];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    calls.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('reloadAllTimelines', () {
    test('invokes reloadAllTimelines without arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return null;
          });

      await WidgetKit.reloadAllTimelines();

      expect(calls, hasLength(1));
      expect(calls.single.method, 'reloadAllTimelines');
      expect(calls.single.arguments, isNull);
    });
  });

  group('reloadTimelines', () {
    test('invokes reloadTimelines with ofKind payload', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return null;
          });

      await WidgetKit.reloadTimelines('weather');

      expect(calls, hasLength(1));
      expect(calls.single.method, 'reloadTimelines');
      expect(calls.single.arguments, <String, Object?>{'ofKind': 'weather'});
    });
  });

  group('getItem', () {
    test('returns the channel result and forwards arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return 'Hello Widget';
          });

      final result = await WidgetKit.getItem<String>(
        'widgetData',
        'group.test',
      );

      expect(result, 'Hello Widget');
      expect(calls, hasLength(1));
      expect(calls.single.method, 'getItem');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'appGroup': 'group.test',
      });
    });

    test('rethrows platform errors from the native layer', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            throw PlatformException(
              code: 'invalid_app_group',
              message:
                  'No shared UserDefaults suite exists for the provided app group.',
            );
          });

      await expectLater(
        () => WidgetKit.getItem<String>('widgetData', 'group.invalid'),
        throwsA(
          isA<PlatformException>().having(
            (error) => error.code,
            'code',
            'invalid_app_group',
          ),
        ),
      );
    });
  });

  group('setItem', () {
    test('returns the channel result and forwards arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return call.arguments['value'];
          });

      final result = await WidgetKit.setItem<String>(
        'widgetData',
        'Updated text',
        'group.test',
      );

      expect(result, 'Updated text');
      expect(calls, hasLength(1));
      expect(calls.single.method, 'setItem');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'value': 'Updated text',
        'appGroup': 'group.test',
      });
    });
  });

  group('removeItem', () {
    test('returns true when the channel confirms removal', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return true;
          });

      final result = await WidgetKit.removeItem('widgetData', 'group.test');

      expect(result, isTrue);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'removeItem');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'appGroup': 'group.test',
      });
    });

    test('falls back to false when the channel returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            calls.add(call);
            return null;
          });

      final result = await WidgetKit.removeItem('widgetData', 'group.test');

      expect(result, isFalse);
      expect(calls.single.method, 'removeItem');
    });
  });
}
