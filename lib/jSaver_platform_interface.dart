import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jSaver_method_channel.dart';

abstract class JSaverPlatform extends PlatformInterface {
  /// Constructs a JSaverPlatform.
  JSaverPlatform() : super(token: _token);

  static final Object _token = Object();

  static JSaverPlatform _instance = MethodChannelJSaver();

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

  Future<String> saveFileData(
      {required String fName, required Uint8List fData}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
