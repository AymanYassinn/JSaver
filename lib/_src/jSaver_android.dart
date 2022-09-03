import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:jsaver/jsaver_platform_interface.dart';

/// [String] MethodChannel [_METHOD_CHANNEL]
const String _METHOD_CHANNEL = "JSAVER";

///[String] MethodName [_SAVE_FILE]
const String _SAVE_FILE = "SaveFile";

class JSaverAndroid extends JSaverPlatform {
  ///[String] method [_baseName] that takes the [String] path and return the name
  ///example:
  /// path = "emulated/Downloads/image.png";
  /// String name = baseName(path);
  /// name will be [String] image.png
  String _baseName(String path) => path.substring(path.lastIndexOf("/") + 1);

  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel(_METHOD_CHANNEL);

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [FileType] type
  /// has [String] return Value
  @override
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      FileType type = FileType.OTHER}) async {
    try {
      if (data.isNotEmpty && name.isNotEmpty) {
        if (name.split(".").isNotEmpty) {
          final aVal = await _saveFileData(fName: name, fData: data);
          return aVal;
        } else {
          return "You Must Provide file extension";
        }
      } else {
        return "Check File , Name";
      }
    } catch (e) {
      return e.toString();
    }
  }

  ///[Future] method [saveFromPath]
  ///takes the [String] path
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  @override
  Future<String> saveFromPath({required String path}) async {
    try {
      if (path.isNotEmpty) {
        final value = File(path);
        if (value.existsSync()) {
          final fData = value.readAsBytesSync();
          if (fData.isNotEmpty) {
            final fName = _baseName(path);
            final aVal = await _saveFileData(fName: fName, fData: fData);
            return aVal;
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

  ///[Future] method [saveFromFile]
  ///takes the [File] file from dart:io
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  @override
  Future<String> saveFromFile({required File file}) async {
    try {
      if (file.existsSync()) {
        final fData = file.readAsBytesSync();
        if (fData.isNotEmpty) {
          final fName = _baseName(file.path);
          final aVal = await _saveFileData(fName: fName, fData: fData);
          return aVal;
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

  ///[Future] method [_saveFileData]
  ///takes the [Uint8List] fData and [String] fName
  ///Call [MethodChannel] and [invokeMethod] that has [String] return Value
  Future<String> _saveFileData(
      {required String fName, required Uint8List fData}) async {
    final vPath = await methodChannel
        .invokeMethod<String>(_SAVE_FILE, {"data": fData, "name": fName});
    if (vPath != null) {
      return vPath;
    } else {
      return "Check Permissions";
    }
  }
}
