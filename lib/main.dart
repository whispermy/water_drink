import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  var now = new DateTime.now();
  String dateToday = '';
  String timeToday = '';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    now = DateTime.now();
    dateToday = now.toString().substring(0,10);
    return File('$path/$dateToday.txt');
  }

  Future<String> readCounter() async {
    String contents = '';
    try {
      final file = await _localFile;
      // Read the file
      contents = await file.readAsString();

      return contents;
      // return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      contents = 'ERROR: file read error.';
      writeCounter(contents);
      return contents;
    }
  }

  Future<File> writeCounter(String data) async {
    final file = await _localFile;
    now = DateTime.now();
    timeToday = now.toString().substring(10,19);

    // Write the file
    return file.writeAsString('SAVE TIME: $dateToday$timeToday VALUES: $data');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int drinkedwater = 0;
  String value = '';

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        String temp = value.substring(39,);
        print('temp: $temp');
        drinkedwater = int.parse(temp);
        print('init value is $value');
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      drinkedwater = drinkedwater + 300;
    });

    // Write the variable as a string to the file.
    value = '$drinkedwater';
    return widget.storage.writeCounter(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Drinked water App'),
        backgroundColor: Colors.teal[200],
      ),
      body: Column(
        children: [
          Text(
            'you drinked water $drinkedwater ml.',
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Save and Increment',
            child: const Icon(Icons.add),
            backgroundColor: Colors.teal[200],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ), 
    );
  }
}