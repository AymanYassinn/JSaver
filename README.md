# jsaver

JSaver: Just An Amazing File Saver Plugin That Save Files To User Choice Directory On Android , Web & Windows.

## Features

- Save From List Of Files, Paths, FileModel.
- Save From File.
- Save From Uint8List
- Save From Path

## Usage
To Use `jsaver`

#Android
Minimal SDK VERSION
```groovy
minSdkVersion 19
```
#Web
The Only Method Works For Web.
```dart

final _jSaverPlugin = JSaver();

Future<String> getFromData(Uint8List data, String fileName)async{
  //Note: File Name Must Contain extension
  final value = await _jSaverPlugin.saveFromData(data: data, name: fileName);
return value;
}

```
## Simple Usage

```dart

final _jSaverPlugin = JSaver();

Future<String> saveFromPath(String path)async{
 final value =  await _jSaverPlugin.saveFromPath(path: path);
 return value;
}
Future<String> saveFromData(Uint8List data, String fileName)async{
  //Note: File Name Must Contain extension
  final value = await _jSaverPlugin.saveFromData(data: data, name: fileName);
return value;
}


Future<String> saveFromFile(File file)async{
  final value = await _jSaverPlugin.saveFromFile(file: file);
  return value;
}
Future<String> saveFromList({List<String> paths = const [],
  List<File> files = const [],
  List<FilesModel> dataList = const []})async{
  final value = await _jSaverPlugin.saveListOfFiles(files:files, paths:paths, dataList:dataList);
  return value;
}
```
## Additional information

Provided By [Just Codes Developers](https://jucodes.com/)