import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

/// [String] MethodChannel [METHOD_CHANNEL]
const String METHOD_CHANNEL = "JSAVER";

///[String] MethodName [SAVE_FILE]
const String SAVE_FILE = "SaveFile";

///[methodChannel] constant as [MethodChannel]
const methodChannel = MethodChannel(METHOD_CHANNEL);

///[String] method [baseName] that takes the [String] path and return the name
///example:
/// path = "emulated/Downloads/image.png";
/// String name = baseName(path);
/// name will be [String] image.png
String baseName(String path) => path.substring(path.lastIndexOf("/") + 1);

///[File] method [toFile] that takes the [String] path and return [File]
///example:
/// path = "emulated/Downloads/image.png";
/// File file = toFile(path);
/// file will be [File] from dart:io
File toFile(String path) => File(path);

///[Uint8List] method [toData] that takes the [File] file and return [Uint8List]
///example:
/// path = "emulated/Downloads/image.png";
/// File file = toFile(path);
/// Uint8List uint8List = toData(file);
/// uint8List will be [Uint8List]
Uint8List toData(File file) => file.readAsBytesSync();

///[Future] method [saveFileData]
///takes the [Uint8List] fData and [String] fName
///Call [MethodChannel] and [invokeMethod] that has [String] return Value
Future<String> saveFileData(
    {required String fName, required Uint8List fData}) async {
  final vPath = await methodChannel
      .invokeMethod<String>(SAVE_FILE, {"data": fData, "name": fName});
  if (vPath != null) {
    return vPath;
  } else {
    return "Check Permissions";
  }
}

/// [JSaver] IS the Main Class you Can Call it like
/// final jSaver = JSaver();
///or
///JSaver().method()

class JSaver {
  ///[Future] method [saveFromFile]
  ///takes the [File] file from dart:io
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromFile({required File file}) async {
    try {
      if (file.existsSync()) {
        final fData = toData(file);
        if (fData.isNotEmpty) {
          final fName = baseName(file.path);
          return await saveFileData(fName: fName, fData: fData);
        } else {
          return "Couldn't Read File Data";
        }
      } else {
        return "NotExist";
      }
    } catch (e) {
      return e.toString();
    }
  }

  ///[Future] method [saveFromPath]
  ///takes the [String] path
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromPath({required String path}) async {
    try {
      if (path.isNotEmpty) {
        final value = toFile(path);
        if (value.existsSync()) {
          final fData = toData(value);
          if (fData.isNotEmpty) {
            final fName = baseName(path);
            return await saveFileData(fName: fName, fData: fData);
          } else {
            return "Couldn't Read File Data";
          }
        } else {
          return "NotExist";
        }
      } else {
        return "No Path";
      }
    } catch (e) {
      return e.toString();
    }
  }

  ///[Future] method [saveFromData]
  ///takes [Uint8List] data and [String] name
  ///return [String] value the path of savedFile
  Future<String> saveFromData(
      {required Uint8List data, required String name}) async {
    try {
      if (data.isNotEmpty && name.isNotEmpty) {
        return await saveFileData(fName: name, fData: data);
      } else {
        return "Check File , Name";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
