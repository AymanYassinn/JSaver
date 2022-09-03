import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jSaver.dart';

void main() {
  JSaver platform = JSaver();
  const MethodChannel channel = MethodChannel('jsaver');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.saveFromPath(path: ""), '42');
  });
}
