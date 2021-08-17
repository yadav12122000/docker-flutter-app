// import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'main.dart';

class MyTerminal extends StatefulWidget {
  const MyTerminal({Key? key}) : super(key: key);

  @override
  _MyTerminalState createState() => _MyTerminalState();
}

class _MyTerminalState extends State<MyTerminal> {
  runCmd(cmdname) async {
    //  print(cmdname);
    final url = Uri.http(Global.ip, "/cgi-bin/cmd.py", {"x": cmdname});
    var response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    setState(() {
      output = response.body;
    });
  }

  var myCmdController = TextEditingController();
  String output = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          // Container(
          //   margin: EdgeInsets.all(10),
          //       height: MediaQuery.of(context).size.height*0.75,
          //       decoration: BoxDecoration(color: Colors.blueGrey),
          Column(
        children: [
          SizedBox(
            height: 5,
          ),
          // Container(
          //   margin: EdgeInsets.all(10),
          //   child: TextField(
          //     controller: myCmdController,
          //     decoration: InputDecoration(
          //       labelText: 'Name',
          //       icon: Icon(Icons.keyboard),
          //     ),
          //   ),
          // ),
          TextFormField(
            autocorrect: false,
            autovalidateMode: AutovalidateMode.disabled,
            controller: myCmdController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.blue),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.keyboard),
                hintText: "e.g. docker version",
                labelText: "Enter Docker Commands"),
            cursorHeight: 30.0,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                runCmd(myCmdController.text);
              },
              child: Text("Run")),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(output,
                          style: TextStyle(
                            fontSize: 20,
                          )))))
        ],
      ),
    );
  }
}
