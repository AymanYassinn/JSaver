import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jsaver/_src/_jSaverAndroid.dart';
import 'package:jsaver/_windows/_jStud.dart'
    if (dart.library.io) 'package:jsaver/_windows/_jSaverWin.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

enum JSaverFileType {
  ///[WINDOWS_FILE] for .all extensions
  WINDOWS_FILE,

  ///[WINDOWS_VIDEO] for .videos extensions
  WINDOWS_VIDEO,

  ///[WINDOWS_IMAGE] for .images extensions
  WINDOWS_IMAGE,

  ///[WINDOWS_MEDIA] for .allMedia extensions
  WINDOWS_MEDIA,

  ///[WINDOWS_AUDIO] for .audio extensions
  WINDOWS_AUDIO,

  ///[AVI] for .avi extension
  AVI,

  ///[BMP] for .bmp extension
  BMP,

  ///[EPUB] for .epub extention
  EPUB,

  ///[GIF] for .gif extension
  GIF,

  ///[JSON] for .json extension
  JSON,

  ///[MPEG] for .mpeg extension
  MPEG,

  ///[MP3] for .mp3 extension
  MP3,

  ///[OTF] for .otf extension
  OTF,

  ///[PNG] for .png extension
  PNG,

  ///[ZIP] for .zip extension
  ZIP,

  ///[TTF] for .ttf extension
  TTF,

  ///[RAR] for .rar extension
  RAR,

  ///[JPEG] for .jpeg extension
  JPEG,

  ///[AAC] for .aac extension
  AAC,

  ///[PDF] for .pdf extension
  PDF,

  ///[OPENDOCSHEETS] for .ods extension
  OPENDOCSHEETS,

  ///[OPENDOCPRESENTATION] for .odp extension
  OPENDOCPRESENTATION,

  ///[OPENDOCTEXT] for .odt extension
  OPENDOCTEXT,

  ///[MICROSOFTWORD] for .docx extension
  MICROSOFTWORD,

  ///[MICROSOFTEXCEL] for .xlsx extension
  MICROSOFTEXCEL,

  ///[MICROSOFTPRESENTATION] for .pptx extension
  MICROSOFTPRESENTATION,

  ///[TEXT] for .txt extension
  TEXT,

  ///[CSV] for .csv extension
  CSV,

  ///[ASICE] for .asice
  ASICE,

  ///[ASICS] for .asice
  ASICS,

  ///[BDOC] for .asice
  BDOC,

  ///[OTHER] for other extension
  OTHER
}

///[AndroidPathOptions] Class
class AndroidPathOptions {
  AndroidPathOptions(
      {this.toDefaultDirectory = false, this.cleanCache = false});
  bool toDefaultDirectory = false;
  bool cleanCache = false;
}

///[String] _[getType] Method
String getType(JSaverFileType type) {
  switch (type) {
    case JSaverFileType.WINDOWS_FILE:
      return 'All Files (*.*)\x00*.*\x00\x00';
    case JSaverFileType.WINDOWS_VIDEO:
      return 'Videos (*.avi,*.flv,*.mkv,*.mov,*.mp4,*.mpeg,*.webm,*.wmv)\x00*.avi;*.flv;*.mkv;*.mov;*.mp4;*.mpeg;*.webm;*.wmv\x00\x00';
    case JSaverFileType.WINDOWS_AUDIO:
      return 'Audios (*.aac,*.midi,*.mp3,*.ogg,*.wav)\x00*.aac;*.midi;*.mp3;*.ogg;*.wav\x00\x00';
    case JSaverFileType.WINDOWS_MEDIA:
      return 'Videos (*.avi,*.flv,*.mkv,*.mov,*.mp4,*.mpeg,*.webm,*.wmv)\x00*.avi;*.flv;*.mkv;*.mov;*.mp4;*.mpeg;*.webm;*.wmv\x00Images (*.bmp,*.gif,*.jpeg,*.jpg,*.png)\x00*.bmp;*.gif;*.jpeg;*.jpg;*.png\x00\x00';
    case JSaverFileType.WINDOWS_IMAGE:
      return 'Images (*.bmp,*.gif,*.jpeg,*.jpg,*.png)\x00*.bmp;*.gif;*.jpeg;*.jpg;*.png\x00\x00';
    case JSaverFileType.AVI:
      return 'video/x-msvideo';
    case JSaverFileType.AAC:
      return 'audio/aac';
    case JSaverFileType.BMP:
      return 'image/bmp';
    case JSaverFileType.EPUB:
      return 'application/epub+zip';
    case JSaverFileType.GIF:
      return 'image/gif';
    case JSaverFileType.JSON:
      return 'application/json';
    case JSaverFileType.MPEG:
      return 'video/mpeg';
    case JSaverFileType.MP3:
      return 'audio/mpeg';
    case JSaverFileType.JPEG:
      return 'image/jpeg';
    case JSaverFileType.OTF:
      return 'font/otf';
    case JSaverFileType.PNG:
      return 'image/png';
    case JSaverFileType.OPENDOCPRESENTATION:
      return 'application/vnd.oasis.opendocument.presentation';
    case JSaverFileType.OPENDOCTEXT:
      return 'application/vnd.oasis.opendocument.text';
    case JSaverFileType.OPENDOCSHEETS:
      return 'application/vnd.oasis.opendocument.spreadsheet';
    case JSaverFileType.PDF:
      return 'application/pdf';
    case JSaverFileType.TTF:
      return 'font/ttf';
    case JSaverFileType.ZIP:
      return 'application/zip';
    case JSaverFileType.MICROSOFTEXCEL:
      return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    case JSaverFileType.MICROSOFTPRESENTATION:
      return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
    case JSaverFileType.MICROSOFTWORD:
      return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    case JSaverFileType.ASICE:
      return "application/vnd.etsi.asic-e+zip";
    case JSaverFileType.ASICS:
      return "application/vnd.etsi.asic-s+zip";
    case JSaverFileType.BDOC:
      return "application/vnd.etsi.asic-e+zip";
    case JSaverFileType.OTHER:
      return "application/octet-stream";
    case JSaverFileType.TEXT:
      return 'text/plain';
    case JSaverFileType.CSV:
      return 'text/csv';
    default:
      return "application/octet-stream";
  }
}

String joinPath(String fDir, String fPath) {
  String value = '';
  String path = Platform.isWindows
      ? fPath.replaceAll("/", Platform.pathSeparator)
      : fPath;
  String dir =
      Platform.isWindows ? fDir.replaceAll("/", Platform.pathSeparator) : fDir;
  if (dir.endsWith(Platform.pathSeparator) &&
      path.startsWith(Platform.pathSeparator)) {
    value = dir + path.substring(1);
  } else if (!dir.endsWith(Platform.pathSeparator) &&
      !path.startsWith(Platform.pathSeparator)) {
    value = dir + Platform.pathSeparator + path;
  } else {
    value = dir + path;
  }
  return value;
}

///[FilesModel] Class
class FilesModel {
  String _name = '', _value = '';
  Uint8List? _data;

  /// [String] getter [valueName]
  String get valueName => _name;

  /// [String] getter [value]
  String get value => _value;

  /// [Uint8List] getter [data]
  Uint8List? get data => _data;

  /// [FilesModel] Constructor
  FilesModel([this._name = '', this._value = '', this._data]);

  /// [FilesModel] Constructor
  FilesModel.fromMap(var data) {
    _name = data["01"].toString();
    _value = data["02"].toString();
  }

  /// [toMap] _[Map]
  toMap() => {
        "01": _name,
        "02": _value,
      };

  ///an override [toString] _[String]
  @override
  String toString() {
    return json.encode(toMap());
  }
}

abstract class JSaver extends PlatformInterface {
  /// Constructs a JSaverPlatform.
  JSaver() : super(token: _token);

  static final Object _token = Object();

  static JSaver _instance = JSaver._setPlatform();

  /// The default instance of [JSaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelJSaver].
  static JSaver get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JSaverPlatform] when
  /// they register themselves.
  static set instance(JSaver instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  factory JSaver._setPlatform() {
    if (Platform.isAndroid) {
      return JSaverAndroid();
    } else if (Platform.isWindows) {
      return jSaverFFI();
    } else {
      throw UnimplementedError(
        'The current platform "${Platform.operatingSystem}" is not supported by this plugin.',
      );
    }
  }

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [JSaverFileType] type
  /// has [String] return Value
  Future<String> saveFromData(
          {required Uint8List data,
          required String name,
          JSaverFileType type = JSaverFileType.OTHER}) async =>
      throw UnimplementedError('saveFromData() has not been implemented.');

  ///[Future] method [grantAccessToDirectory]
  /// has [FilesModel] return Value
  Future<FilesModel> grantAccessToDirectory() async => throw UnimplementedError(
      'grantAccessToDirectory() has not been implemented.');

  ///[Future] method [getAccessedDirectories]
  /// has [List] of [FilesModel] as return Value
  Future<List<FilesModel>> getAccessedDirectories() async =>
      throw UnimplementedError(
          'getAccessedDirectories() has not been implemented.');

  ///[Future] method [getDefaultSavingDirectory]
  /// has [FilesModel] return Value
  Future<FilesModel> getDefaultSavingDirectory() async =>
      throw UnimplementedError(
          'getDefaultSavingDirectory() has not been implemented.');

  ///[Future] method [setDefaultSavingDirectory]
  /// has [FilesModel] return Value
  Future<FilesModel> setDefaultSavingDirectory() async =>
      throw UnimplementedError(
          'setDefaultSavingDirectory() has not been implemented.');

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
  Future<List<FilesModel>> save(
          {String toDirectory = "",
          String fromPath = "",
          File? fromFile,
          FilesModel? fromData,
          List<String> fromPaths = const [],
          List<File> fromFiles = const [],
          List<FilesModel> fromDataList = const [],
          AndroidPathOptions? androidPathOptions}) async =>
      throw UnimplementedError('save() has not been implemented.');

  ///[Future] method [getCacheDirectory]
  /// has [String] return Value
  Future<String> getCacheDirectory() async =>
      throw UnimplementedError('getCacheDirectory() has not been implemented.');

  ///[Future] method [cleanAppCacheDirs]
  ///take [bool] _ [cleanDefault]
  ///take [bool] _ [cleanAccessedDirs]
  ///take [bool] _ [cleanCache]
  /// has [String] return Value
  Future<String> cleanAppCacheDirs(
          {bool cleanDefault = false,
          bool cleanAccessedDirs = false,
          bool cleanCache = true}) async =>
      throw UnimplementedError('cleanAppCacheDirs() has not been implemented.');
}
