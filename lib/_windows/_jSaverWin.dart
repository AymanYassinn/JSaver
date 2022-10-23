import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:jsaver/_windows/_jFFi.dart';
import 'package:jsaver/jSaver.dart';

///[String] method [_fileNameCC] that takes the [String] fileName
/// return checked Value
String _fileNameCC(String fileName) {
  if (fileName.contains(RegExp(r'''[<>:\/\\|?*"]'''))) {
    return "";
  } else {
    return fileName;
  }
}

JSaver jSaverFFI() => JSaverWindows();

class JSaverWindows extends JSaver {
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

  ///[Future] method [save]
  ///has [String] _ [fromPath]
  ///has [String] _ [toDirectory]
  ///has [File] _ [fromFile]
  ///has [FilesModel] _ [fromData]
  ///has [List] of [String]_ [fromPaths]
  ///has [List] of [File]_ [fromFiles]
  ///has [List] of [FilesModel]_ [fromDataList]
  ///has [AndroidPathOptions] _ [androidPathOptions]
  /// has [List] of [FilesModel] return Value
  @override
  Future<List<FilesModel>> save(
      {String toDirectory = "",
      String fromPath = "",
      File? fromFile,
      FilesModel? fromData,
      List<String> fromPaths = const [],
      List<File> fromFiles = const [],
      List<FilesModel> fromDataList = const [],
      AndroidPathOptions? androidPathOptions}) async {
    List<FilesModel> successList = [];
    try {
      if (fromPath.isEmpty &&
          fromData == null &&
          fromFile == null &&
          fromPaths.isEmpty &&
          fromFiles.isEmpty &&
          fromDataList.isEmpty) {
        successList.add(FilesModel("Source Data", "No Source Data Found"));
        return successList;
      } else {
        List<FilesModel> fSourceList = [];
        if (fromPath.isNotEmpty) {
          final fPName = _checkFilePath(fromPath);
          if (fPName.isNotEmpty) {
            final file = File(fromPath);
            final fS = FilesModel(fPName, "", file.readAsBytesSync());
            fSourceList.add(fS);
          }
        }
        if (fromFile != null) {
          final fPName = _checkFilePath(fromFile.path);
          if (fPName.isNotEmpty) {
            final fS = FilesModel(fPName, "", fromFile.readAsBytesSync());
            fSourceList.add(fS);
          }
        }
        if (fromData != null) {
          if (fromData.value.isNotEmpty) {
            final fPName = _checkFilePath(fromData.value);
            if (fPName.isNotEmpty) {
              final file = File(fromData.value);
              final fS = FilesModel(fPName, "", file.readAsBytesSync());
              fSourceList.add(fS);
            }
          } else if (fromData.data != null) {
            if (fromData.valueName.isNotEmpty &&
                fromData.data!.isNotEmpty &&
                fromData.valueName.split(".").isNotEmpty) {
              final fPName = fromData.valueName.contains("/")
                  ? fromData.valueName.replaceAll("/", Platform.pathSeparator)
                  : fromData.valueName;
              final fS = FilesModel(fPName, "", fromData.data);
              fSourceList.add(fS);
            }
          }
        }
        if (fromPaths.isNotEmpty) {
          for (var i in fromPaths) {
            final fPName = _checkFilePath(i);
            if (fPName.isNotEmpty) {
              final file = File(i);
              final fS = FilesModel(fPName, "", file.readAsBytesSync());
              fSourceList.add(fS);
            }
          }
        }
        if (fromFiles.isNotEmpty) {
          for (var i in fromFiles) {
            final fPName = _checkFilePath(i.path);
            if (fPName.isNotEmpty) {
              final fS = FilesModel(fPName, "", i.readAsBytesSync());
              fSourceList.add(fS);
            }
          }
        }
        if (fromDataList.isNotEmpty) {
          for (var i in fromDataList) {
            if (i.value.isNotEmpty) {
              final fPName = _checkFilePath(i.value);
              if (fPName.isNotEmpty) {
                final file = File(i.value);
                final fS = FilesModel(fPName, "", file.readAsBytesSync());
                fSourceList.add(fS);
              }
            } else if (i.data != null) {
              if (i.valueName.isNotEmpty &&
                  i.data!.isNotEmpty &&
                  i.valueName.split(".").isNotEmpty) {
                final fPName = i.valueName.contains("/")
                    ? i.valueName.replaceAll("/", Platform.pathSeparator)
                    : i.valueName;
                final fS = FilesModel(fPName, "", i.data);
                fSourceList.add(fS);
              }
            }
          }
        }
        if (fSourceList.isNotEmpty) {
          String aVal1 = "";

          if (toDirectory.isNotEmpty) {
            final fDirectory = Directory(joinPath(toDirectory, ""));
            if (fDirectory.existsSync()) {
              aVal1 = fDirectory.path;
            } else {
              aVal1 = await _saveFile(fileName: fSourceList.first.valueName);
            }
          } else {
            aVal1 = await _saveFile(fileName: fSourceList.first.valueName);
          }
          final fType = _baseType(fSourceList.first.valueName);
          if (aVal1.isNotEmpty && aVal1.endsWith(fType)) {
            final aVal3 = aVal1.substring(
                0, aVal1.lastIndexOf(Platform.pathSeparator) + 1);
            for (var i in fSourceList) {
              final fF = File(joinPath(aVal3, i.valueName));
              fF.writeAsBytesSync(i.data!);
              successList.add(FilesModel(i.valueName, i.value));
            }
          }
          return successList;
        } else {
          successList.add(FilesModel("Source Data", "No Source Data Found"));
          return successList;
        }
      }
    } catch (e) {
      successList.add(FilesModel("Exception", e.toString()));
      return successList;
    }
  }

  String _checkFilePath(String path) {
    if (path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return _baseName(path);
      }
    }
    return "";
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
      defaultFileName: fileName.isEmpty ? "file" : fileName,
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
          .map<String>((filePath) => joinPath(directoryPath, filePath))
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
