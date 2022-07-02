import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'home.dart';
import 'login.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('db');
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Vision Impairment Helper System"),
          centerTitle: true,
        ),
        body: InitPage(),
      ),
    );
  }
}

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Box box;
  @override
  void initState() {
    super.initState();
    connectDb();
  }

  void connectDb() async {
    box = await Hive.openBox('db');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (box == null)
        ? Center(child: CircularProgressIndicator())
        : (box.get('name') == null)
            ? LoginPage(
                box: this.box,
                updateState: () {
                  if (mounted) {
                    setState(() {});
                  }
                },
              )
            : HomePage(cameras, box);
  }
}
