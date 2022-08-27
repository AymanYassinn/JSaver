import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jSaver.dart';

void main() {
  final platform = JSaver();
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
    expect(await platform.saveFromData(name: "", data: Uint8List(10)), '42');
  });
}
