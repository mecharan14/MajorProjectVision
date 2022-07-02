import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'bndbox.dart';
import 'camera.dart';
import 'dart:math' as math;

import 'models.dart';

class DetectionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String model;
  final Function updateResults, listenOrStop;
  final bool isListening;

  const DetectionPage(
      {Key key,
      this.cameras,
      this.model,
      this.updateResults,
      this.listenOrStop,
      this.isListening})
      : super(key: key);
  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  setRecognitions(recognitions, imageHeight, imageWidth) {
    if (mounted)
      setState(() {
        _recognitions = recognitions;
        _imageHeight = imageHeight;
        _imageWidth = imageWidth;
      });
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    print(res);
  }

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    loadModel();
  }

  @override
  void dispose() {
    widget.updateResults("Start detection first.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: widget.listenOrStop,
        child: Icon(widget.isListening ? Icons.mic : Icons.mic_off_outlined),
      ),
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
            widget.updateResults,
          ),
          BndBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
    );
  }
}
