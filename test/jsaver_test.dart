import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jsaver.dart';
import 'package:jsaver/jsaver_platform_interface.dart';
import 'package:jsaver/jsaver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJSaverPlatform
    with MockPlatformInterfaceMixin
    implements JSaverPlatform {
  @override
  Future<String> saveFileData(
      {required String fName, required Uint8List fData}) {
    // TODO: implement saveFileData
    throw UnimplementedError();
  }
}

void main() {
  final JSaverPlatform initialPlatform = JSaverPlatform.instance;

  test('$MethodChannelJSaver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJSaver>());
  });

  test('getPlatformVersion', () async {
    JSaver jsaverPlugin = JSaver();
    MockJSaverPlatform fakePlatform = MockJSaverPlatform();
    JSaverPlatform.instance = fakePlatform;

    expect(await jsaverPlugin.saveFromPath(path: ""), '42');
  });
}
