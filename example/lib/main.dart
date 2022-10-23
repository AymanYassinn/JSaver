import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jsaver/jSaver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _savedFile = 'Unknown';
  final _jSaverPlugin = JSaver.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('$_savedFile\n'),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: '1',
              onPressed: () async {
                await savedWeb();
              },
              child: const Icon(Icons.web),
            ),
            FloatingActionButton(
              heroTag: '2',
              onPressed: () async {
                await Permission.storage.request();
                final val = await _jSaverPlugin.grantAccessToDirectory();
                debugPrint(val.toString());
                setState(() {
                  _savedFile = val.toString();
                });
              },
              child: const Icon(Icons.lock_open),
            ),
            FloatingActionButton(
              heroTag: '3',
              onPressed: () async {
                await Permission.storage.request();
                final val = await _jSaverPlugin.getAccessedDirectories();
                for (var i in val) {
                  debugPrint(i.toString());
                }
                setState(() {
                  _savedFile = val.first.toString();
                });
              },
              child: const Icon(Icons.storage),
            ),
            FloatingActionButton(
              heroTag: '4',
              onPressed: () async {
                final val = await _jSaverPlugin.setDefaultSavingDirectory();
                debugPrint(val.toString());
                setState(() {
                  _savedFile = val.toString();
                });
              },
              child: const Icon(Icons.maps_home_work),
            ),
            FloatingActionButton(
              heroTag: '5',
              onPressed: () async {
                final val = await _jSaverPlugin.getDefaultSavingDirectory();
                debugPrint(val.toString());
                setState(() {
                  _savedFile = val.toString();
                });
              },
              child: const Icon(Icons.home),
            ),
            FloatingActionButton(
              heroTag: '6',
              onPressed: () async {
                final val = await saveAll();
                if (val.isNotEmpty) {
                  for (var i in val) {
                    debugPrint(i.toString());
                  }
                  setState(() {
                    _savedFile = val.first.toString();
                  });
                }
              },
              child: const Icon(Icons.save),
            ),
            FloatingActionButton(
              heroTag: '6',
              onPressed: () async {
                final val = await _jSaverPlugin.getCacheDirectory();
                debugPrint(val.toString());
                setState(() {
                  _savedFile = val.toString();
                });
              },
              child: const Icon(Icons.cached_sharp),
            ),
            FloatingActionButton(
              heroTag: '7',
              onPressed: () async {
                final val = await _jSaverPlugin.cleanApplicationCache();
                debugPrint(val.toString());
                setState(() {
                  _savedFile = val.toString();
                });
              },
              child: const Icon(Icons.cleaning_services),
            ),
          ],
        ),
      ),
    );
  }

  savedWeb() async {
    final val = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (val != null) {
      if (val.files.isNotEmpty) {
        final file = val.files.first;
        if (file.bytes != null) {
          debugPrint(file.extension.toString());
          debugPrint(file.name.toString());
          debugPrint(file.bytes.toString());
          final v = await _jSaverPlugin.saveFromData(
              data: file.bytes!, name: file.name);
          setState(() {
            _savedFile = v;
          });
          debugPrint(v.toString());
        }
      }
    }
  }

  Future<List<FilesModel>> saveAll() async {
    await Permission.storage.request();
    final val = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (val != null) {
      if (val.paths.isNotEmpty || val.files.isNotEmpty) {
        List<String> paths = [];
        List<File> files = [];
        List<FilesModel> filesData = [];
        for (var i in val.paths) {
          if (i != null) {
            paths.add(i);
            //  filesData.add(FilesModel(fPath: i));
          }
        }
        for (var i in val.files) {
          if (i.path != null) {
            final vF = File(i.path!);
            files.add(vF);

            filesData.add(FilesModel(
                vF.path
                    .substring(vF.path.lastIndexOf(Platform.pathSeparator) + 1),
                "",
                vF.readAsBytesSync()));
          }
        }
        final v = await _jSaverPlugin.save(
          fromPath: paths.first,
          fromFile: files.first,
          fromData: filesData.first,
          fromFiles: files,
          fromPaths: paths,
          fromDataList: filesData,
          toDirectory: "/storage/emulated/0/Example/Example1/Example2/Example3",
          androidPathOptions: AndroidPathOptions(
            cleanCache: true,
            toDefaultDirectory: false,
          ),
        );
        return v;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
