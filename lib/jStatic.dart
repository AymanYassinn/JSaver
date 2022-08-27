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
///```dart
/// path = "emulated/Downloads/image.png";
/// String name = baseName(path);
/// ```
/// name will be [String] image.png
String baseName(String path) => path.substring(path.lastIndexOf("/") + 1);

///[File] method [toFile] that takes the [String] path and return [File]
///example:
///```dart
/// path = "emulated/Downloads/image.png";
/// File file = toFile(path);
/// ```
/// file will be [File] from dart:io
File toFile(String path) => File(path);

///[Uint8List] method [toData] that takes the [File] file and return [Uint8List]
///example:
///```dart
/// path = "emulated/Downloads/image.png";
/// File file = toFile(path);
/// Uint8List uint8List = toData(file);
/// ```
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
