import 'package:flutter/material.dart';
import 'package:mydockerun/terminal.dart';
import 'myimg.dart';
import 'contview.dart';
import 'terminal.dart';

class MyWorkPage extends StatefulWidget {
  const MyWorkPage({Key? key}) : super(key: key);

  @override
  _MyWorkPageState createState() => _MyWorkPageState();
}

class _MyWorkPageState extends State<MyWorkPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 3,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.blueAccent.shade200,
              title: Text("Docker"),
              titleTextStyle: TextStyle(
                color: Colors.deepOrange,
                fontSize: 30,
              ),
              bottom: TabBar(
                tabs: [
                  Text(
                    "Container",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Images",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Terminal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              MyCont(),
              MyImage(),
              MyTerminal(),
            ]),
          ));
  }
}

