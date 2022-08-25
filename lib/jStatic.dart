import 'dart:io';
import 'dart:typed_data';

const String METHOD_CHANNEL = "JSAVER";
const String SAVE_FILE = "SaveFile";

String baseName(String na) => na.substring(na.lastIndexOf("/") + 1);
String baseType(String na) => na.substring(na.lastIndexOf("."));
String baseName2(String na) => "${DateTime.now().millisecondsSinceEpoch}.$na";
File toFile(String path) => File(path);
Uint8List toData(File file) => file.readAsBytesSync();
