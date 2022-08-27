import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jsaver.dart';

class MockJSaverPlatform {
  Future<String> saveFileData(
      {required String fName, required Uint8List fData}) {
    // TODO: implement saveFileData
    throw UnimplementedError();
  }
}

void main() {
  final initialPlatform = JSaver();

  test('$initialPlatform is the default instance', () {});

  test('getPlatformVersion', () async {
    JSaver jsaverPlugin = JSaver();

    expect(await jsaverPlugin.saveFromPath(path: ""), '42');
  });
}
