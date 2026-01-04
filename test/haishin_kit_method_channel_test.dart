import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/method_channel_haishin_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelHaishinKit platform = MethodChannelHaishinKit();
  const MethodChannel channel = MethodChannel('com.haishinkit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
