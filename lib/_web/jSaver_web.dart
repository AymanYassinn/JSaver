// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:typed_data';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:jsaver/jSaver.dart';

/// A web implementation of the JSaverPlatform of the JSaver plugin.
class JSaverWeb extends JSaver {
  /// Constructs a JSaverWeb
  JSaverWeb();

  static void registerWith(Registrar registrar) {
    JSaver.instance = JSaverWeb();
  }

  ///[Future] method [_webSaver]
  ///takes the [Uint8List] bytes and [String] name
  /// has [bool] return Value
  Future<bool> _webSaver(Uint8List bytes, String name, String type) async {
    try {
      String url = Url.createObjectUrlFromBlob(Blob([bytes], type));
      HtmlDocument htmlDocument = document;
      AnchorElement anchor = htmlDocument.createElement('a') as AnchorElement;
      anchor.href = url;
      anchor.style.display = name;
      anchor.download = name;
      document.body!.children.add(anchor);
      anchor.click();
      document.body!.children.remove(anchor);
      return true;
    } catch (e) {
      return false;
    }
  }

  ///[Future] method [saveFromData]
  ///takes the [Uint8List] bytes and [String] name and [FileType] type
  /// has [String] return Value
  @override
  Future<String> saveFromData(
      {required Uint8List data,
      required String name,
      FileType type = FileType.OTHER}) async {
    try {
      final wVal = await _webSaver(data, name, "application/octet-stream");
      return wVal.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
