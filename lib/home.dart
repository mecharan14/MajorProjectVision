import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vision2/detection.dart';

import 'models.dart';
import 'textResult.dart';
import 'button.dart';
import 'help.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Box box;

  HomePage(this.cameras, this.box);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String results = "Start detection first.";
  FlutterTts flutterTts = FlutterTts();
  final SpeechRecognition _speech = SpeechRecognition();
  String text = "";
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    initSTT();
  }

  void initSTT() async {
    await _speech.activate("en-US");
    _speech.setRecognitionCompleteHandler(handleVoiceResult);
  }

  void handleVoiceResult(String text) async {
    if (text.trim().length > 0) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$text")));
      this.text = text;
    }
    doCommand(text);
  }

  void doCommand(String text) async {
    const String name = "vision";
    // final String userName = box.get('name');
    final String userName = "Charan";
    final trimmedText = text.toLowerCase().trim();
    if (trimmedText == "hi $name" ||
        trimmedText == "hello $name" ||
        trimmedText == "hai $name") {
      await _speak("Hello $userName");
    }
    if (trimmedText == "stop") {
      stopListening();
      return;
    }

    if (trimmedText == "back") {
      Navigator.pop(context);
    }

    if (trimmedText.startsWith("$name")) {
      if (trimmedText.contains("can you read it") ||
          trimmedText.contains("read out")) {
        await textRecognizer();
      }
      if (trimmedText.contains("open detection")) {
        _speak("starting detection");
        onSelect(yolo);
      }

      if (trimmedText.contains("what do you see")) {
        await _speak(results);
      }

      if (trimmedText.contains("how are you")) {
        await _speak("I'm good $userName. Thank you for asking.");
      }
    }

    await Future.delayed(Duration(milliseconds: 1000));
    if (isListening) {
      listen();
    }
  }

  onSelect(model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetectionPage(
          model: model,
          cameras: widget.cameras,
          updateResults: this.updateResults,
          isListening: this.isListening,
          listenOrStop: this.listenOrStop,
        ),
      ),
    );
  }

  updateResults(objects) {
    results = objects;
    print("Results : $results");
  }

  void stopListening() {
    if (isListening) {
      _speech.cancel();
      _speech.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  Future<GoogleVisionImage> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final PickedFile image = await _picker.getImage(source: ImageSource.camera);
    final GoogleVisionImage visionImage =
        GoogleVisionImage.fromFile(File(image.path));
    return visionImage;
  }

  Future textRecognizer() async {
    final GoogleVisionImage visionImage = await getImage();
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TextResult(
                  text: visionText.text,
                )));
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
  }

  void listen() async {
    await _speech.listen();
  }

  void listenOrStop() {
    if (!isListening) {
      setState(() {
        isListening = true;
      });
      listen();
    } else {
      stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(isListening ? Icons.mic : Icons.mic_off_outlined),
        onPressed: listenOrStop,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome ${widget.box.get('name')}!",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            // ElevatedButton(
            //   child: const Text(ssd),
            //   onPressed: () => onSelect(ssd),
            // ),
            UIButton(
              text: "Object Detection",
              icon: Icons.center_focus_weak,
              onPressed: () => onSelect(yolo),
            ),
            // ElevatedButton(
            //   child: const Text(mobilenet),
            //   onPressed: () => onSelect(mobilenet),
            // ),
            // ElevatedButton(
            //   child: const Text(posenet),
            //   onPressed: () => onSelect(posenet),
            // ),
            UIButton(
              text: "Text Recognition",
              icon: Icons.text_fields,
              onPressed: () => textRecognizer(),
            ),

            Divider(
              color: Colors.black,
            ),

            UIButton(
              text: "Help",
              icon: Icons.help_outline,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HelpPage(),
                  )),
            ),
            UIButton(
              text: "About The Project",
              icon: Icons.info_outline,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AboutPage(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
