import 'dart:io';

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsaver/jSaver.dart';
import 'package:jsaver/jsaver_platform_interface.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJsaverPlatform
    with MockPlatformInterfaceMixin
    implements JSaverPlatform {
  @override
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      FileType type = FileType.OTHER}) {
    throw UnimplementedError();
  }

  @override
  Future<String> saveFromFile({required File file}) {
    throw UnimplementedError();
  }

  @override
  Future<String> saveFromPath({required String path}) {
    throw UnimplementedError();
  }

  @override
  Future<String> saveListOfFiles(
      {List<String> paths = const [],
      List<File> files = const [],
      List<FilesModel> dataList = const []}) {
    throw UnimplementedError();
  }
}

void main() {
  test('getPlatformVersion', () async {
    JSaver jsaverPlugin = JSaver();
    MockJsaverPlatform fakePlatform = MockJsaverPlatform();
    JSaverPlatform.instance = fakePlatform;

    expect(await jsaverPlugin.saveFromPath(path: "path"), '42');
  });
}
