import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:jsaver/_windows/jFFi.dart';
import 'package:jsaver/jsaver_platform_interface.dart';

import 'package:path/path.dart';

///[String] method [_fileNameCC] that takes the [String] fileName
/// return checked Value
String _fileNameCC(String fileName) {
  if (fileName.contains(RegExp(r'[<>:\/\\|?*"]'))) {
    return "";
  } else {
    return fileName;
  }
}

JSaverPlatform jSaverFFI() => JSaverWindows();

class JSaverWindows extends JSaverPlatform {
  ///[String] method [_baseName] that takes the [String] path and return the name
  ///example:
  /// path = "emulated/Downloads/image.png";
  /// String name = baseName(path);
  /// name will be [String] image.png
  String _baseName(String path) =>
      path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);

  ///[String] method [_baseType] that takes the [String] path and return the extension
  ///example:
  /// path = "emulated/Downloads/image.png";
  /// String name = _baseType(path);
  /// extension will be [String] .png
  String _baseType(String path) => path.substring(path.lastIndexOf("."));

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [FileType] type
  /// has [String] return Value
  @override
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      FileType type = FileType.WINDOWS_FILE}) async {
    try {
      if (data.isNotEmpty && name.isNotEmpty) {
        if (name.split(".").isNotEmpty) {
          final fType = _baseType(name);
          final val = await _saveFile(fileName: name);
          if (val.isNotEmpty) {
            if (val.endsWith(fType)) {
              final fF = File(val);
              fF.writeAsBytesSync(data);
              return fF.path;
            } else {
              final fF = File(val);
              fF.writeAsBytesSync(data);
              var newPath = val.substring(
                      0, val.lastIndexOf(Platform.pathSeparator) + 1) +
                  _baseName(val) +
                  fType;
              fF.renameSync(newPath);
              return newPath;
            }
          } else {
            return "Couldn't Write File Data";
          }
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
            final fType = _baseType(path);
            final val = await _saveFile(fileName: fName);
            if (val.isNotEmpty) {
              if (val.endsWith(fType)) {
                final fF = File(val);
                fF.writeAsBytesSync(fData);
                return fF.path;
              } else {
                final fF = File(val);
                fF.writeAsBytesSync(fData);
                var newPath = val.substring(
                        0, val.lastIndexOf(Platform.pathSeparator) + 1) +
                    _baseName(val) +
                    fType;
                fF.renameSync(newPath);
                return newPath;
              }
            } else {
              return "Couldn't Write File Data";
            }
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
          final fType = _baseType(file.path);
          final val = await _saveFile(fileName: fName);
          if (val.isNotEmpty) {
            if (val.endsWith(fType)) {
              final fF = File(val);
              fF.writeAsBytesSync(fData);
              return fF.path;
            } else {
              final fF = File(val);
              fF.writeAsBytesSync(fData);
              var newPath = val.substring(
                      0, val.lastIndexOf(Platform.pathSeparator) + 1) +
                  _baseName(val) +
                  fType;
              fF.renameSync(newPath);
              return newPath;
            }
          } else {
            return "Couldn't Write File Data";
          }
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

  Future<String> _saveFile({
    required String fileName,
    FileType type = FileType.WINDOWS_FILE,
  }) async {
    final comdlg32 = DynamicLibrary.open('comdlg32.dll');
    final getSaveFileNameW =
        comdlg32.lookupFunction<GetSaveFileNameW, GetSaveFileNameWDart>(
            'GetSaveFileNameW');

    final Pointer<OPENFILENAMEW> openFileNameW = _instantiateOpenFileNameW(
      defaultFileName: fileName,
      type: type,
    );

    final result = getSaveFileNameW(openFileNameW);
    String returnValue = '';
    if (result == 1) {
      final filePaths = _getFileFromOpen(
        openFileNameW.ref,
      );
      returnValue = filePaths.first;
    }

    _freeMemory(openFileNameW);
    return returnValue;
  }

  List<String> _getFileFromOpen(
    OPENFILENAMEW openFileNameW,
  ) {
    final List<String> filePaths = [];
    final buffer = StringBuffer();
    int i = 0;
    bool lastCharWasNull = false;

    // ignore: literal_only_boolean_expressions
    while (true) {
      final char = openFileNameW.lpstrFile.cast<Uint16>().elementAt(i).value;
      if (char == 0) {
        if (lastCharWasNull) {
          break;
        } else {
          filePaths.add(buffer.toString());
          buffer.clear();
          lastCharWasNull = true;
        }
      } else {
        lastCharWasNull = false;
        buffer.writeCharCode(char);
      }
      i++;
    }

    if (filePaths.length > 1) {
      final String directoryPath = filePaths.removeAt(0);

      return filePaths
          .map<String>((filePath) => join(directoryPath, filePath))
          .toList();
    }

    return filePaths;
  }

  Pointer<OPENFILENAMEW> _instantiateOpenFileNameW({
    String defaultFileName = "file",
    FileType type = FileType.WINDOWS_FILE,
  }) {
    const lpstrFileBufferSize = 8192 * maximumPathLength;
    final Pointer<OPENFILENAMEW> openFileNameW = calloc<OPENFILENAMEW>();
    openFileNameW.ref.lStructSize = sizeOf<OPENFILENAMEW>();
    openFileNameW.ref.lpstrTitle = ("Save $defaultFileName").toNativeUtf16();
    openFileNameW.ref.lpstrFile = calloc.allocate<Utf16>(lpstrFileBufferSize);
    openFileNameW.ref.lpstrFilter = getType(type).toNativeUtf16();
    openFileNameW.ref.nMaxFile = lpstrFileBufferSize;
    //openFileNameW.ref.lpstrInitialDir = ('').toNativeUtf16();
    openFileNameW.ref.flags = ofnExplorer | ofnFileMustExist | ofnHideReadOnly;
    if (_fileNameCC(defaultFileName).isNotEmpty) {
      final Uint16List nativeString = openFileNameW.ref.lpstrFile
          .cast<Uint16>()
          .asTypedList(maximumPathLength);
      final safeName = defaultFileName.substring(
        0,
        min(maximumPathLength - 1, defaultFileName.length),
      );
      final units = safeName.codeUnits;
      nativeString.setRange(0, units.length, units);
      nativeString[units.length] = 0;
    }

    return openFileNameW;
  }

  void _freeMemory(Pointer<OPENFILENAMEW> openFileNameW) {
    calloc.free(openFileNameW.ref.lpstrTitle);
    calloc.free(openFileNameW.ref.lpstrFile);
    calloc.free(openFileNameW.ref.lpstrFilter);
    calloc.free(openFileNameW.ref.lpstrInitialDir);
    calloc.free(openFileNameW);
  }
}
