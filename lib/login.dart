import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  final Box box;
  final Function updateState;

  const LoginPage({Key key, this.box, this.updateState}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textEditingController = TextEditingController();

  void login() {
    if (textEditingController.text.trim().length > 3) {
      setState(() {
        widget.box.put('name', textEditingController.text.trim());
      });
    }
    widget.updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enter Name",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Minimum 4 characters",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}
