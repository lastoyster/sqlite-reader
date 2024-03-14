import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Read Sqflite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Read Sqflite Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _dbPath;
  List<String> _tableNames = [];
  List<String> _columnNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Press the button to open an SQLite DB file',
            ),
            if (_dbPath != null) ...[
              Text('DB Path: $_dbPath'),
              Text('Table Names: $_tableNames'),
              Text('Column Names: $_columnNames'),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilePicker,
        tooltip: 'Open SQLite DB file',
        child: Icon(Icons.file_open),
      ),
    );
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String dbPath = file.path;
      _dbPath = dbPath;

      Database database = await openDatabase(
        dbPath,
        readOnly: true,
      );

      List<Map<String, dynamic>> tables = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );

      _tableNames = tables.map((table) => table['name'].toString()).toList();

      if (_tableNames.isNotEmpty) {
        String firstTableName = _tableNames.first;
        List<Map<String, dynamic>> columns = await database.rawQuery(
          "PRAGMA table_info($firstTableName)",
        );
        _columnNames =
            columns.map((column) => column['name'].toString()).toList();
      } else {
        _columnNames.clear();
      }

      setState(() {});
    } else {
      print('User canceled the picker');
    }
  }
}
