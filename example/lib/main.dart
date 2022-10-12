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
  final _jSaverPlugin = JSaver();

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
          child: Text('Path: $_savedFile\n'),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: '1',
              onPressed: () async {
                await savedAndroid();
              },
              child: const Icon(Icons.android),
            ),
            FloatingActionButton(
              heroTag: '2',
              onPressed: () async {
                await savedWindows();
              },
              child: const Icon(Icons.desktop_windows),
            ),
            FloatingActionButton(
              heroTag: '3',
              onPressed: () async {
                await savedWeb();
              },
              child: const Icon(Icons.web),
            ),
            FloatingActionButton(
              heroTag: '4',
              onPressed: () async {
                await savedFileList();
              },
              child: const Icon(Icons.list),
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

  savedWindows() async {
    final val = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (val != null) {
      if (val.files.isNotEmpty) {
        final file = val.files.first;
        if (file.path != null) {
          final file2 = File(file.path!);
          final v = await _jSaverPlugin.saveFromFile(file: file2);
          setState(() {
            _savedFile = v;
          });
          debugPrint(v.toString());
        }
      }
    }
  }

  savedAndroid() async {
    await Permission.storage.request();
    final val = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (val != null) {
      if (val.files.isNotEmpty) {
        final file = val.files.first;
        if (file.path != null) {
          final v = await _jSaverPlugin.saveFromPath(path: file.path!);
          setState(() {
            _savedFile = v;
          });
          debugPrint(v.toString());
        }
      }
    }
  }

  savedFileList() async {
    await Permission.storage.request();
    final val = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (val != null) {
      if (val.paths.isNotEmpty || val.files.isNotEmpty) {
        List<String> paths = [];
        List<File> files = [];
        for (var i in val.paths) {
          if (i != null) {
            paths.add(i);
          }
        }
        for (var i in val.files) {
          if (i.path != null) {
            files.add(File(i.path!));
          }
        }
        final v =
            await _jSaverPlugin.saveListOfFiles(paths: paths, files: files);
        setState(() {
          _savedFile = v;
        });
        debugPrint(v.toString());
      }
    }
  }
}
