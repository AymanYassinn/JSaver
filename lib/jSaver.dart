import 'dart:io';
import 'dart:typed_data';
export 'package:jsaver/jStatic.dart';
import 'package:jsaver/jStatic.dart';

/// [JSaver] IS the Main Class you Can Call it like
/// ```dart
/// final jSaver = JSaver();
/// ```
///or
///``` dart
///JSaver().method()
///```
class JSaver {
  /// Save From File [saveFromFile] It Take [File] from dart:io and return [String] Path
  /// Or It Can Return [String] ERROR From catch()
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

  /// Save From Path [saveFromPath]  It Takes [String] Path Return [String] Path
  /// Or It Can Return [String] ERROR From catch()
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

  /// Save From Data [saveFromData] It Takes [Uint8List] data and [String] name Return [String] Path
  /// Or It Can Return [String] ERROR From catch()
  Future<String> saveFromData(
      {required Uint8List data, required String name}) async {
    try {
      if (data.isNotEmpty && name.isNotEmpty) {
        return await saveFileData(fName: name, fData: data);
      } else {
        return "Check File , Name Or Type";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
