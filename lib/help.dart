import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  final name = "Vision";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "List of Commands: ",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 30,
            ),
            Command(
              command: "Hi / Hai / Hello $name",
              result: "$name will great you.",
            ),
            Divider(),
            Command(
              command: "$name open detection",
              result: "$name will start recognizing objects through camera.",
            ),
            Divider(),
            Command(
              command: "$name read out",
              result: "$name will scan text by camera.",
            ),
            Divider(),
            Command(
              command: "$name can you read it",
              result: "$name will scan text by camera.",
            ),
            Divider(),
            Command(
              command: "$name how are you",
              result: "$name will reply.",
            ),
            Divider(),
            Command(
              command: "Back",
              result: "$name stop & close object detection.",
            ),
            Divider(),
            Command(
              command: "Stop",
              result: "$name will stop listening to your voice.",
            ),
          ],
        ),
      ),
    );
  }
}

class Command extends StatelessWidget {
  final String command, result;

  const Command({Key key, this.command, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.mic,
            color: Colors.grey,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              command,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              result,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
