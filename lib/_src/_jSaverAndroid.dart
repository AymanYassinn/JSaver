import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:jsaver/jSaver.dart';

/// [String] MethodChannel [_METHOD_CHANNEL]
const String _METHOD_CHANNEL = "JSAVER";

///[String] MethodName [_SET_ACCESS]
///[String] MethodName [_GET_CASH_PATH]
///[String] MethodName [_GET_DEFAULT_PATH]
///[String] MethodName [_SET_DEFAULT_PATH]
///[String] MethodName [_SAVER_MAIN]
///[String] MethodName [_GET_ACCESSED_DIR]
///[String] MethodName [_CLEAN_CASH_PATH]
///[String] MethodName [_GET_APP_DIR]

const String _SET_ACCESS = "SetAccessDirectory";
const String _GET_CASH_PATH = "GetCashDirectory";
const String _CLEAN_CASH_PATH = "ClearCache";
const String _GET_DEFAULT_PATH = "GetDefaultPath";
const String _SET_DEFAULT_PATH = "SetDefaultPath";
const String _SAVER_MAIN = "SaverMain";
const String _GET_ACCESSED_DIR = "GetAccessedDirectories";
const String _GET_APP_DIR = "GetApplicationDirectory";

class JSaverAndroid extends JSaver {
  ///[String] method [_baseName] that takes the [String] path and return the name
  ///example:
  /// path = "emulated/Downloads/image.png";
  /// String name = baseName(path);
  /// name will be [String] image.png
  String _baseName(String path) => path.substring(path.lastIndexOf("/") + 1);

  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel(_METHOD_CHANNEL);

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
      {String toDirectory = '',
      String fromPath = "",
      File? fromFile,
      FilesModel? fromData,
      List<String> fromPaths = const [],
      List<File> fromFiles = const [],
      List<FilesModel> fromDataList = const [],
      AndroidPathOptions? androidPathOptions}) async {
    List<FilesModel> successList = [];
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
      final fCache = await getCacheDirectory();
      if (fromPath.isNotEmpty) {
        final fPName = _checkFilePath(fromPath);
        if (fPName.isNotEmpty) {
          final fS = FilesModel(fPName, fromPath);
          fSourceList.add(fS);
        }
      }
      if (fromFile != null) {
        final fPName = _checkFilePath(fromFile.path);
        if (fPName.isNotEmpty) {
          final fS = FilesModel(fPName, fromFile.path);
          fSourceList.add(fS);
        }
      }
      if (fromData != null) {
        if (fromData.value.isNotEmpty) {
          final fPName = _checkFilePath(fromData.value);
          if (fPName.isNotEmpty) {
            final fS = FilesModel(fPName, fromData.value);
            fSourceList.add(fS);
          }
        } else if (fromData.data != null) {
          if (fromData.valueName.isNotEmpty &&
              fromData.data!.isNotEmpty &&
              fromData.valueName.split(".").isNotEmpty) {
            if (fCache.contains("/cache")) {
              final fFile = File(joinPath(fCache, fromData.valueName));
              fFile.writeAsBytesSync(fromData.data!);
              final fPName = _checkFilePath(fFile.path);
              if (fPName.isNotEmpty) {
                final fS = FilesModel(fPName, fFile.path);
                fSourceList.add(fS);
              }
            }
          }
        }
      }
      if (fromPaths.isNotEmpty) {
        for (var i in fromPaths) {
          final fPName = _checkFilePath(i);
          if (fPName.isNotEmpty) {
            final fS = FilesModel(fPName, i);
            fSourceList.add(fS);
          }
        }
      }
      if (fromFiles.isNotEmpty) {
        for (var i in fromFiles) {
          final fPName = _checkFilePath(i.path);
          if (fPName.isNotEmpty) {
            final fS = FilesModel(fPName, i.path);
            fSourceList.add(fS);
          }
        }
      }
      if (fromDataList.isNotEmpty) {
        for (var i in fromDataList) {
          if (i.value.isNotEmpty) {
            final fPName = _checkFilePath(i.value);
            if (fPName.isNotEmpty) {
              final fS = FilesModel(fPName, i.value);
              fSourceList.add(fS);
            }
          } else if (i.data != null) {
            if (i.valueName.isNotEmpty &&
                i.data!.isNotEmpty &&
                i.valueName.split(".").isNotEmpty) {
              if (fCache.contains("/cache")) {
                final fFile = File(joinPath(fCache, i.valueName));
                fFile.writeAsBytesSync(i.data!);
                final fPName = _checkFilePath(fFile.path);
                if (fPName.isNotEmpty) {
                  final fS = FilesModel(fPName, fFile.path);
                  fSourceList.add(fS);
                }
              }
            }
          }
        }
      }
      if (fSourceList.isNotEmpty) {
        AndroidPathOptions jAndroidPathOptions = AndroidPathOptions();
        if (androidPathOptions != null) {
          jAndroidPathOptions = androidPathOptions;
        }
        final aVal = await _saveMainMethod(
            dataList: fSourceList,
            saverPathSettings: jAndroidPathOptions,
            toDirectory: toDirectory);
        if (aVal.isNotEmpty) {
          for (var i in aVal) {
            successList.add(FilesModel.fromMap(json.decode(i)));
          }
        }
        return successList;
      } else {
        successList.add(FilesModel("Source Data", "No Source Data Found"));
        return successList;
      }
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

  ///[Future] method [getDefaultSavingDirectory]
  /// has [FilesModel] return Value
  @override
  Future<FilesModel> getDefaultSavingDirectory() async {
    final value = await methodChannel.invokeMethod<String>(_GET_DEFAULT_PATH);
    if (value != null) {
      return FilesModel.fromMap(json.decode(value));
    } else {
      return FilesModel("", "");
    }
  }

  ///[Future] method [getDefaultSavingDirectory]
  /// has [FilesModel] return Value
  @override
  Future<List<FilesModel>> getAccessedDirectories() async {
    final value =
        await methodChannel.invokeListMethod<String>(_GET_ACCESSED_DIR);
    List<FilesModel> filesM = [];
    if (value != null) {
      if (value.isNotEmpty) {
        for (var i in value) {
          filesM.add(FilesModel.fromMap(json.decode(i)));
        }
        return filesM;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  ///[Future] method [grantAccessToDirectory]
  /// has [FilesModel] return Value
  @override
  Future<FilesModel> grantAccessToDirectory() async {
    final value = await methodChannel.invokeMethod<String>(_SET_ACCESS);
    if (value != null) {
      return FilesModel.fromMap(json.decode(value));
    } else {
      return FilesModel("", "");
    }
  }

  ///[Future] method [setDefaultSavingDirectory]
  /// has [FilesModel] return Value
  @override
  Future<FilesModel> setDefaultSavingDirectory() async {
    final value = await methodChannel.invokeMethod<String>(_SET_DEFAULT_PATH);
    if (value != null) {
      return FilesModel.fromMap(json.decode(value));
    } else {
      return FilesModel("", "");
    }
  }

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [JSaverFileType] type
  /// has [String] return Value
  @override
  Future<String> saveFromData(
          {required Uint8List data,
          required String name,
          JSaverFileType type = JSaverFileType.OTHER}) async =>
      throw UnimplementedError('saveFromData() Is Implemented For Web Only');

  ///[Future] method [getCacheDirectory]
  /// has [String] return Value
  @override
  Future<String> getCacheDirectory() async {
    final vPath = await methodChannel.invokeMethod<String>(_GET_CASH_PATH);
    if (vPath != null) {
      return vPath;
    } else {
      return "Check Permissions";
    }
  }

  ///[Future] method [getApplicationDirectory]
  /// has [String] return Value
  @override
  Future<String> getApplicationDirectory() async {
    final vPath = await methodChannel.invokeMethod<String>(_GET_APP_DIR);
    if (vPath != null) {
      return vPath;
    } else {
      return "S";
    }
  }

  ///[Future] method [cleanAppCacheDirs]
  ///take [bool] _ [cleanDefault]
  ///take [bool] _ [cleanAccessedDirs]
  ///take [bool] _ [cleanCache]
  /// has [String] return Value
  @override
  Future<String> cleanAppCacheDirs(
      {bool cleanDefault = false,
      bool cleanAccessedDirs = false,
      bool cleanCache = true}) async {
    final vPath = await methodChannel.invokeMethod<String>(_CLEAN_CASH_PATH, {
      "accessed": cleanAccessedDirs,
      "default": cleanDefault,
      "cache": cleanCache
    });
    if (vPath != null) {
      return vPath;
    } else {
      return "Check Permissions";
    }
  }

  Future<List<String>> _saveMainMethod(
      {List<FilesModel> dataList = const [],
      required AndroidPathOptions saverPathSettings,
      String toDirectory = ''}) async {
    List<Map<dynamic, dynamic>> list = [];
    for (var i in dataList) {
      list.add(i.toMap());
    }
    if (list.isNotEmpty) {
      final vPath = await methodChannel.invokeListMethod<String>(_SAVER_MAIN, {
        "dataList": list,
        "default": saverPathSettings.toDefaultDirectory,
        "directory": toDirectory,
        "cleanCache": saverPathSettings.cleanCache
      });
      if (vPath != null) {
        return vPath;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
