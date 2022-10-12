import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'jsaver_platform_interface.dart';

class JSaver {
  ///[Future] method [saveFromFile]
  ///takes the [File] file from dart:io
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromFile({required File file}) async {
    return JSaverPlatform.instance.saveFromFile(file: file);
  }

  ///[Future] method [saveFromPath]
  ///takes the [String] path
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromPath({required String path}) async {
    return JSaverPlatform.instance.saveFromPath(path: path);
  }

  ///[Future] method [saveFromData]
  ///takes [Uint8List] data and [String] name
  ///[name] Must Contains .extension
  ///return [String] value the path of savedFile
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      FileType type = FileType.OTHER}) async {
    return JSaverPlatform.instance
        .saveFromData(data: data, name: name, type: type);
  }

  ///[Future] method [saveListOfFiles]
  ///takes the [List] of [String] paths ,  and [List] of [File] files
  ///and [List] of [FilesModel] dataList
  /// has [String] return Value
  Future<String> saveListOfFiles(
      {List<String> paths = const [],
      List<File> files = const [],
      List<FilesModel> dataList = const []}) async {
    return JSaverPlatform.instance
        .saveListOfFiles(paths: paths, files: files, dataList: dataList);
  }
}
