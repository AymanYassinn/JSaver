# jsaver

JSaver: Just An Amazing File Saver Plugin That Save Files To User Choice Directory On Android , Web , Linux & Windows.

## Features
- Set Default Directory For Saving
- get Default Directory For Saving
- get Application Directory
- get Cache Directory & Clean Cache Directory
- Save From List Of Files, Paths, FilesModel.
- Save From File.
- Save From Uint8List
- Save From Path


## Usage
To Use `jsaver`

#Android
Minimal SDK VERSION
```groovy
minSdkVersion 21
```
#Web
The Only Method Works For Web.
```dart

final _jSaverPlugin = JSaver();

Future<String> saveFromData(Uint8List data, String fileName)async{
  //Note: File Name Must Contain extension
  final value = await _jSaverPlugin.saveFromData(data: data, name: fileName);
return value;
}

```
## Simple Usage

```dart

final _jSaverPlugin = JSaver.instance;
```
Set & Get Default Directory
```dart
Future<FilesModel> setDefaultDirectory()async{
  final value =  await _jSaverPlugin.setDefaultSavingDirectory();
  return value;
}

Future<FilesModel> getDefaultDirectory()async{
 final value =  await _jSaverPlugin.getDefaultSavingDirectory();
 return value;
}


```

Grant Access To Directory & Get Accessed Directories
```dart
Future<FilesModel> grantAccessToDirectory()async{
 final value =  await _jSaverPlugin.grantAccessToDirectory();
 return value;
}
Future<List<FilesModel>> getAccessedDirectories()async{
  final value =  await _jSaverPlugin.getAccessedDirectories();
  return value;
}
```

Get & Clean Cache Directory
```dart
 Future<String> getApplicationCacheDirectory() async {
  final value = await _jSaverPlugin.getCacheDirectory();
  return value;
}

 Future<String> cleanApplicationCacheDirectory() async {
  final value = await _jSaverPlugin.cleanApplicationCache();
  return value;
}
```
Save All Method
```dart
FilesModel fileModel = FilesModel("File Name With Extension", "Full File Path", [Uint8List data]);
//If You Add File Path in Files Model Don't Add File Name And Data

FilesModel fileModel = FilesModel("", "", [Uint8List data]);
// If You Add File Data You Must Add File Name With EXTENSION And Leave Path Empty
Future<List<FilesModel>> save()async{
  final file1 = File("/storage/emulated/0/SourceFolder/file.jpg");
  final fileModel1 = FilesModel("file.jpg", "", file1.readAsBytesSync());
  final fileModel2 = FilesModel("", "/storage/emulated/0/SourceFolder/file.jpg");
  final value =  await _jSaverPlugin.save(
    fromPath: file1.path,
    fromFile: file1,
    fromData: fileModel1 || fileModel2,
    fromFiles: [file1],
    fromPaths: [file1.path],
    fromDataList: [fileModel1, fileModel2],
    toDirectory: "/storage/emulated/0/TargetFolder"|| "D:/Folder/TargetFolder" ,
    androidPathOptions: AndroidPathOptions(
      cleanCache: true,
      toDefaultDirectory: false,
    ),
  );
  return value;
}
```

## Additional information

Provided By [Just Codes Developers](https://jucodes.com/)