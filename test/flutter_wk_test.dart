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

  group('reload', () {
    test('invokes reload without arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });

      await WidgetKit.reload();

      expect(calls, hasLength(1));
      expect(calls.single.method, 'reload');
      expect(calls.single.arguments, isNull);
    });
  });

  group('reloadOfKind', () {
    test('invokes reloadOfKind with ofKind payload', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });

      await WidgetKit.reloadOfKind('weather');

      expect(calls, hasLength(1));
      expect(calls.single.method, 'reloadOfKind');
      expect(calls.single.arguments, <String, Object?>{'ofKind': 'weather'});
    });
  });

  group('read', () {
    test('returns the channel result and forwards arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return 'Hello Widget';
          });

      final result = await WidgetKit.read<String>('widgetData', 'group.test');

      expect(result, 'Hello Widget');
      expect(calls, hasLength(1));
      expect(calls.single.method, 'read');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'appGroup': 'group.test',
      });
    });

    test('rethrows platform errors from the native layer', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(
              code: 'invalid_app_group',
              message:
                  'No shared UserDefaults suite exists for the provided app group.',
            );
          });

      await expectLater(
        () => WidgetKit.read<String>('widgetData', 'group.invalid'),
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

  group('write', () {
    test('returns the channel result and forwards arguments', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return call.arguments['value'];
          });

      final result = await WidgetKit.write<String>(
        'widgetData',
        'Updated text',
        'group.test',
      );

      expect(result, 'Updated text');
      expect(calls, hasLength(1));
      expect(calls.single.method, 'write');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'value': 'Updated text',
        'appGroup': 'group.test',
      });
    });
  });

  group('remove', () {
    test('returns true when the channel confirms removal', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return true;
          });

      final result = await WidgetKit.remove('widgetData', 'group.test');

      expect(result, isTrue);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'remove');
      expect(calls.single.arguments, <String, Object?>{
        'key': 'widgetData',
        'appGroup': 'group.test',
      });
    });

    test('falls back to false when the channel returns null', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return null;
          });

      final result = await WidgetKit.remove('widgetData', 'group.test');

      expect(result, isFalse);
      expect(calls.single.method, 'remove');
    });
  });
}
