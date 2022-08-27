import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jsaver/jSaver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
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
        floatingActionButton: FloatingActionButton(onPressed: () async {
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
        }),
      ),
    );
  }
}
