import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jsaver_method_channel.dart';

void main() {
  MethodChannelJSaver platform = MethodChannelJSaver();
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
    expect(await platform.saveFileData(fName: "", fData: Uint8List(10)), '42');
  });
}
