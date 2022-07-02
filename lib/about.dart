import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "Vision Impairment Helper System",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Vision is a personal assistant app which helps low vision people to seek help through cameras.",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Project Members",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text("D. Surya Charan (18RE1A0502)"),
            SizedBox(
              height: 5,
            ),
            Text("G. Prashanth (18RE1A0504)"),
            SizedBox(
              height: 5,
            ),
            Text("MB. Akhil Raj (18RE1A0516)"),
            SizedBox(
              height: 5,
            ),
            Text("P. Nithin Reddy (18RE1A0520)"),
          ],
        ),
      ),
    );
  }
}
