import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IsolateExample(),
    );
  }
}

class IsolateExample extends StatefulWidget {
  const IsolateExample({super.key});

  @override
  IsolateExampleState createState() => IsolateExampleState();
}

class IsolateExampleState extends State<IsolateExample> {
  String _result = "Waiting for result...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startBackgroundTask,
              child: const Text('Run Background Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _startBackgroundTask() async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_backgroundTask, receivePort.sendPort);

    receivePort.listen((data) {
      setState(() {
        _result = "Result from Isolate: $data";
      });
    });
  }

  static void _backgroundTask(SendPort sendPort) {
    int sum = 0;
    for (int i = 0; i < 100000000; i++) {
      sum += i;
    }
    sendPort.send(sum);
  }
}
