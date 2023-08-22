import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:jsaver/jSaver.dart';

class JSaverLinux extends JSaver {
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
  ///takes the [Uint8List] bytes and [String] name and [JSaverFileType] type
  /// has [String] return Value
  @override
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      JSaverFileType type = JSaverFileType.WINDOWS_FILE}) async {
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
          if (aVal1.isNotEmpty) {
            final aVal3 = aVal1.endsWith(fType)
                ? aVal1.substring(
                    0, aVal1.lastIndexOf(Platform.pathSeparator) + 1)
                : aVal1;
            for (var i in fSourceList) {
              final fF = File(joinPath(aVal3, i.valueName));
              fF.writeAsBytesSync(i.data!);
              successList.add(FilesModel(i.valueName, fF.path));
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
  }) async {
    final executable = await _getPathToExecutable();
    List<String> arguments = [];
    if (executable.endsWith("zenity") || executable.endsWith('qarma')) {
      arguments = _generateArgumentsQ(fileName: fileName);
    } else {
      arguments = _generateArguments(fileName: fileName);
    }
    return await _runExecutableWithArguments(executable, arguments) ?? "";
  }

  List<String> _generateArguments({
    String fileName = '',
  }) {
    final arguments = ['--title', 'JSaver'];
    arguments.add('--getsavefilename');
    arguments.add(fileName);
    return arguments;
  }

  List<String> _generateArgumentsQ({
    String fileName = '',
  }) {
    final arguments = ['--file-selection', '--title', 'JSaver'];
    arguments.addAll(['--save', '--confirm-overwrite']);
    arguments.add('--filename=$fileName');
    return arguments;
  }

  /// Returns the path to the executables `qarma`, `zenity` or `kdialog` as a
  /// [String].
  /// On Linux, the CLI tools `qarma` or `zenity` can be used to open a native
  /// file picker dialog. It seems as if all Linux distributions have at least
  /// one of these two tools pre-installed (on Ubuntu `zenity` is pre-installed).
  /// On distribuitions that use KDE Plasma as their Desktop Environment,
  /// `kdialog` is used to achieve these functionalities.
  /// The future returns an error, if none of the executables was found on
  /// the path.
  Future<String> _getPathToExecutable() async {
    try {
      try {
        return await _isExecutableOnPath('qarma');
      } on Exception {
        return await _isExecutableOnPath('kdialog');
      }
    } on Exception {
      return await _isExecutableOnPath('zenity');
    }
  }

  Future<String?> _runExecutableWithArguments(
    String executable,
    List<String> arguments,
  ) async {
    final processResult = await Process.run(executable, arguments);
    final path = processResult.stdout?.toString().trim();
    if (processResult.exitCode != 0 || path == null || path.isEmpty) {
      return null;
    }
    return path;
  }

  Future<String> _isExecutableOnPath(String executable) async {
    final path = await _runExecutableWithArguments('which', [executable]);
    if (path == null) {
      throw Exception(
        'Could not find the executable $executable in the path.',
      );
    }
    return path;
  }
}
