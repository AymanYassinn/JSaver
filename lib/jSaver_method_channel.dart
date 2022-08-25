import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jsaver/jStatic.dart';
import 'jSaver_platform_interface.dart';
/// An implementation of [JSaverPlatform] that uses method channels.
class MethodChannelJSaver extends JSaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(METHOD_CHANNEL);

  @override
  Future<String> saveFileData(
      {required String fName, required Uint8List fData}) async {
    final vPath = await methodChannel
        .invokeMethod<String>(SAVE_FILE, {"data": fData, "name": fName});
    if (vPath != null) {
      return vPath;
    } else {
      return "Check Permissions";
    }
  }
}
