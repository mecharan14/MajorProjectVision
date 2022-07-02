import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextResult extends StatefulWidget {
  final String text;

  const TextResult({Key key, this.text}) : super(key: key);
  @override
  _TextResultState createState() => _TextResultState();
}

class _TextResultState extends State<TextResult> {
  TextEditingController textEditingController;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.text);
  }

  void _speak() async {
    await flutterTts.speak(textEditingController.text);
  }

  @override
  void dispose() async {
    await flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
        actions: [
          IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: textEditingController.text.trim()));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Copied Text"),
                ));
              })
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.volume_up), onPressed: _speak),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 50,
                minLines: 1,
                controller: textEditingController,
                style: TextStyle(fontSize: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
