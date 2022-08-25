# jsaver

JSaver: is a plugin that save files in internal or external directories for android.

## Features

- Save From File.
- Save From Uint8List
- Save From Path

## Usage
To Use `jsaver`

Minimal SDK VERSION
```groovy
minSdkVersion 19
```
##Simple Usage

```dart

final _jSaverPlugin = JSaver();

Future<String> getFromPath(String path)async{
 final value =  await _jSaverPlugin.saveFromPath(path: path);
 return value;
}
Future<String> getFromData(Uint8List data, String fileName)async{
  //Note: File Name Must Contain extension
  final value = await _jSaverPlugin.saveFromData(data: data, name: fileName);
return value;
}


Future<String> getFromFile(File file)async{
  final value = await _jSaverPlugin.saveFromFile(file: file);
  return value;
}

```
## Additional information

Provided By [Just Codes Developers](https://jucodes.com/)
"# JSaver" 

