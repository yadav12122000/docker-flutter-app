import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'workpage.dart';
import 'dart:ui' as ui;


main() => runApp(MyApp());
var myController = TextEditingController();
var myportController = TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => MyWorkPage(),
        '/': (BuildContext context) => MyHome(),
      },
    );
  }
}

class Global {
  static String ip = "";
  static String portno = "";
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: CircleAvatar(
        backgroundImage: AssetImage("docker.png"),
        ),
        //  Icon(Icons.ac_unit), 
        // Icon(FontAwesome.glass),
        // ImageIcon(
        //      AssetImage("docker.png"),
        //     //  size: 150,
        //     //  color: Color(0xFF3A5A98),
        //  ),
        title: Text('docker',
  style: TextStyle(
    fontSize: 40,
    foreground: Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 20),
        const Offset(150, 20),
        <Color>[
          Colors.red.shade900,
          Colors.white,
        ],
      )
  ),
),),
      body: Container(
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: MediaQuery.of(context).size.width*0.175),
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*0.50,
              width: MediaQuery.of(context).size.width*0.65,
              decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  boxShadow: [
                    //background color of box
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        8.0, // Move to right 10  horizontally
                        8.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ]),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("New Session",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        )),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // padding: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter IP Address";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                            controller: myController,
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
                                hintText: "e.g. 0.0.0.0",
                                labelText: "Enter IP address"),
                            cursorHeight: 30.0,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Port No.";
                          }
                          return null;
                        },
                        controller: myportController,
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
                            hintText: "e.g. 1234",
                            labelText: "Enter port"),
                        cursorHeight: 30.0,
                        keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10,),
        
                           Container(
                             padding: EdgeInsets.only(left: 15,right: 15),
                             decoration: BoxDecoration(border: Border.all(
                               width: 2,color: Colors.blue.shade500,
                               ),
                               borderRadius: BorderRadius.circular(10),
                               ),
                             child: TextButton(
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      Navigator.pushNamed(context, '/a');
                                      Global.ip = myController.text;
                                      Global.portno = myportController.text;
                                    }
                                  },
                                  child: Text("Login",style:TextStyle(fontSize: 24)),),
                           ),
                        
                       
                        ],
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   // padding: EdgeInsets.all(2),
                      
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(8),
                    //       boxShadow: [
                    //         //background color of box
                    //         BoxShadow(
                    //           color: Colors.blue.shade200,
                    //           blurRadius: 3.0, // soften the shadow
                    //           spreadRadius: 3.0, //extend the shadow
                    //           offset: Offset(
                    //             2.0, // Move to right 10  horizontally
                    //             2.0, // Move to bottom 10 Vertically
                    //           ),
                    //         )
                    //       ]),
                    //   child:
                      
                    // ),
                    ],
                ),
              ),
            ),
    );
  }
}
