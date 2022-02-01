import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:selphid_plugin/selphid_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('selphid_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SelphidPlugin.platformVersion, '42');
  });
}
