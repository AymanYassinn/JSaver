import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jsaver/_src/jSaver_android.dart';
import 'package:jsaver/_windows/stud.dart'
    if (dart.library.io) 'package:jsaver/_windows/jSaver_windows.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

enum FileType {
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

String getType(FileType type) {
  switch (type) {
    case FileType.WINDOWS_FILE:
      return 'All Files (*.*)\x00*.*\x00\x00';
    case FileType.WINDOWS_VIDEO:
      return 'Videos (*.avi,*.flv,*.mkv,*.mov,*.mp4,*.mpeg,*.webm,*.wmv)\x00*.avi;*.flv;*.mkv;*.mov;*.mp4;*.mpeg;*.webm;*.wmv\x00\x00';
    case FileType.WINDOWS_AUDIO:
      return 'Audios (*.aac,*.midi,*.mp3,*.ogg,*.wav)\x00*.aac;*.midi;*.mp3;*.ogg;*.wav\x00\x00';
    case FileType.WINDOWS_MEDIA:
      return 'Videos (*.avi,*.flv,*.mkv,*.mov,*.mp4,*.mpeg,*.webm,*.wmv)\x00*.avi;*.flv;*.mkv;*.mov;*.mp4;*.mpeg;*.webm;*.wmv\x00Images (*.bmp,*.gif,*.jpeg,*.jpg,*.png)\x00*.bmp;*.gif;*.jpeg;*.jpg;*.png\x00\x00';
    case FileType.WINDOWS_IMAGE:
      return 'Images (*.bmp,*.gif,*.jpeg,*.jpg,*.png)\x00*.bmp;*.gif;*.jpeg;*.jpg;*.png\x00\x00';
    case FileType.AVI:
      return 'video/x-msvideo';
    case FileType.AAC:
      return 'audio/aac';
    case FileType.BMP:
      return 'image/bmp';
    case FileType.EPUB:
      return 'application/epub+zip';
    case FileType.GIF:
      return 'image/gif';
    case FileType.JSON:
      return 'application/json';
    case FileType.MPEG:
      return 'video/mpeg';
    case FileType.MP3:
      return 'audio/mpeg';
    case FileType.JPEG:
      return 'image/jpeg';
    case FileType.OTF:
      return 'font/otf';
    case FileType.PNG:
      return 'image/png';
    case FileType.OPENDOCPRESENTATION:
      return 'application/vnd.oasis.opendocument.presentation';
    case FileType.OPENDOCTEXT:
      return 'application/vnd.oasis.opendocument.text';
    case FileType.OPENDOCSHEETS:
      return 'application/vnd.oasis.opendocument.spreadsheet';
    case FileType.PDF:
      return 'application/pdf';
    case FileType.TTF:
      return 'font/ttf';
    case FileType.ZIP:
      return 'application/zip';
    case FileType.MICROSOFTEXCEL:
      return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    case FileType.MICROSOFTPRESENTATION:
      return "application/vnd.openxmlformats-officedocument.presentationml.presentation";
    case FileType.MICROSOFTWORD:
      return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    case FileType.ASICE:
      return "application/vnd.etsi.asic-e+zip";
    case FileType.ASICS:
      return "application/vnd.etsi.asic-s+zip";
    case FileType.BDOC:
      return "application/vnd.etsi.asic-e+zip";
    case FileType.OTHER:
      return "application/octet-stream";
    case FileType.TEXT:
      return 'text/plain';
    case FileType.CSV:
      return 'text/csv';
    default:
      return "application/octet-stream";
  }
}

abstract class JSaverPlatform extends PlatformInterface {
  /// Constructs a JSaverPlatform.
  JSaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static JSaverPlatform _instance = JSaverPlatform._setPlatform();

  /// The default instance of [JSaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelJSaver].
  static JSaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JSaverPlatform] when
  /// they register themselves.
  static set instance(JSaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  factory JSaverPlatform._setPlatform() {
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

  ///[Future] method [saveFromFile]
  ///takes the [File] file from dart:io
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromFile({required File file}) async =>
      throw UnimplementedError('saveFromFile() has not been implemented.');

  ///[Future] method [saveFromPath]
  ///takes the [String] path
  ///return [String] value the path of savedFile
  /// Or It Can return [String] ERROR From catch()
  Future<String> saveFromPath({required String path}) async =>
      throw UnimplementedError('saveFromPath() has not been implemented.');

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [FileType] type
  /// has [String] return Value
  Future<String> saveFromData(
          {required Uint8List data,
          required String name,
          FileType type = FileType.OTHER}) async =>
      throw UnimplementedError('saveFromData() has not been implemented.');
}
