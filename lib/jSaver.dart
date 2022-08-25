import 'dart:io';
import 'dart:typed_data';
export 'package:jsaver/jStatic.dart';
import 'package:jsaver/jStatic.dart';

import 'jSaver_platform_interface.dart';

class JSaver {
  Future<String> saveFromFile({required File file}) async {
    try {
      if (file.existsSync()) {
        final fData = toData(file);
        if (fData.isNotEmpty) {
          final fName = baseName(file.path);
          return JSaverPlatform.instance
              .saveFileData(fName: fName, fData: fData);
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

  Future<String> saveFromPath({required String path}) async {
    try {
      if (path.isNotEmpty) {
        final value = toFile(path);
        if (value.existsSync()) {
          final fData = toData(value);
          if (fData.isNotEmpty) {
            final fName = baseName(path);
            return JSaverPlatform.instance
                .saveFileData(fName: fName, fData: fData);
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

  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      String customType = ''}) async {
    try {
      //String fType = fromTypes(type).isNotEmpty ? fromTypes(type) : customType;
      if (data.isNotEmpty && name.isNotEmpty) {
        return JSaverPlatform.instance.saveFileData(fName: name, fData: data);
      } else {
        return "Check File , Name Or Type";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
