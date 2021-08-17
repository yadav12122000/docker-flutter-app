import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'main.dart';

class MyCont extends StatefulWidget {
  @override
  _MyContState createState() => _MyContState();
}

class _MyContState extends State<MyCont> {
  var myNamecontroller = TextEditingController();
  var myImageController = TextEditingController();
  Future<List<Dcont>> getContainers() async {
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/json", {"all": "1"});
    var response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(response.body);
    // print(result);
    List<Dcont> dconts = [];
    for (var u in result) {
      Dcont dcont = Dcont(
          u["Names"][0].substring(
            1,
          ),
          u["Image"],
          u["NetworkSettings"]["Networks"]["bridge"]["IPAddress"],
          u["Status"]);
      dconts.add(dcont);
    }
    // print(dconts.length);
    return dconts;
    // print(result["NetworkSettings"]);   u["Ports"][0]["PrivatePort"],u["State"]
  }

  Future restartContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http("${Global.ip}:${Global.portno}",
        "/containers/$idContainer/restart", {"t": "5"});
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<List<Continspect>> inspectCont(contname) async {
    final url =
        Uri.http("${Global.ip}:${Global.portno}", "/containers/$contname/json");
    // print(url);
    var response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(response.body);
    //  print(result);
    //  print(result["Image"]);
    //  print(result["Id"]);
    //  print(result["Created"]);
    //  print(result["NetworkSettings"]["IPAddress"]);

    List<Continspect> imags = [];
    Continspect imag = Continspect(
        result["Id"],
        result["Image"],
        result["Created"],
        result["State"]["StartedAt"],
        result["State"]["FinishedAt"],
        result["Runtime"],
        result["NetworkSettings"]["IPAddress"]);
    imags.add(imag);
    return imags;
  }

  Future createContainer(name, imagename) async {
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/create", {"name": name});
    final response = await post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "Image": imagename,
          //  "Cmd": ["echo", "hello world"],
        }));
    var result = jsonDecode(response.body);
    // print(result["Id"]);
    var idC = "";
    idC = result["Id"].substring(0, 12);
    // print(idC);
    startContainer(idC);
  }

  Future startContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/$idContainer/start");
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future stopContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/$idContainer/stop");
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  Future deleteContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/$idContainer",{"v":"1","force":"1"});
    await delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  Future pauseContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/$idContainer/pause");
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  Future unpauseContainer(idContainer) async {
    //  print("my container id is : $idContainer");
    final url = Uri.http(
        "${Global.ip}:${Global.portno}", "/containers/$idContainer/unpause");
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getContainers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(child: Text("Loading....")),
            );
          } else {
            return RefreshIndicator(
              key: refreshkey,
              onRefresh: getContainers,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      horizontalTitleGap: 1,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                      title: Text(snapshot.data[index].name.toString()),
                      subtitle: Text(snapshot.data[index].image.toString()),
                      trailing: Text(snapshot.data[index].status.toString()),
                      leading: PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text(
                                      snapshot.data[index].name.toString()),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        await stopContainer(snapshot
                                            .data[index].name
                                            .toString());
                                        // print("a is $a");
                                        setState(() {
                                          snapshot.data[index].status
                                              .toString();
                                        });
                                      },
                                      child: Text("Stop")),
                                  value: 2,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        await restartContainer(snapshot
                                            .data[index].name
                                            .toString());
                                        // print("a is $a");
                                        setState(() {
                                          snapshot.data[index].status
                                              .toString();
                                        });
                                      },
                                      child: Text("Restart")),
                                  value: 3,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        await pauseContainer(snapshot
                                            .data[index].name
                                            .toString());
                                        // print("a is $a");
                                        setState(() {
                                          snapshot.data[index].status
                                              .toString();
                                        });
                                      },
                                      child: Text("Pause")),
                                  value: 3,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        await unpauseContainer(snapshot
                                            .data[index].name
                                            .toString());
                                        // print("a is $a");
                                        setState(() {
                                          snapshot.data[index].status
                                              .toString();
                                        });
                                      },
                                      child: Text("Unpause")),
                                  value: 3,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        await deleteContainer(snapshot
                                            .data[index].name
                                            .toString());
                                        // print("a is $a");
                                        setState(() {
                                          snapshot.data[index].status
                                              .toString();
                                        });
                                      },
                                      child: Text("Kill")),
                                  value: 3,
                                ),
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () async {
                                        List<Continspect> b = await inspectCont(
                                            snapshot.data[index].name
                                                .toString());
                                        // print("a is ${a[0].name}");},
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                scrollable: true,
                                                title: Text('Details'),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Form(
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        // List<Dcont> a = await containerInspect(snapshot.data[index].name.toString());
                                                        // print("a is ${a[0].name}");},
                                                        Text("Id: ${b[0].id}"),
                                                        Text(
                                                            "Image: ${b[0].image}"),
                                                        Text(
                                                            "Created At: ${b[0].created}"),
                                                        Text(
                                                            "Started time: ${b[0].startedtime}"),
                                                        Text(
                                                            "Finished At: ${b[0].finishedtime}"),
                                                        Text(
                                                            "Runtime: ${b[0].runtime}"),
                                                        Text(
                                                            "IP Address: ${b[0].ipaddr}"),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text("Inspect")),
                                  value: 4,
                                ),
                              ]),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: CircleAvatar(
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Run a container'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: myNamecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  icon: Icon(Icons.keyboard),
                                ),
                              ),
                              TextFormField(
                                controller: myImageController,
                                decoration: InputDecoration(
                                  labelText: 'Image',
                                  icon: Icon(Icons.keyboard),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            child: Text("Create"),
                            onPressed: () {
                              createContainer(myNamecontroller.text,
                                  myImageController.text);
                              Navigator.pop(context);
                              setState(() {});
                            })
                      ],
                    );
                  });
            },
            icon: Icon(Icons.add)),
      ),
    );
  }
}

class Dcont {
  var name;
  var image;
  var status;
  var ipaddr;
  Dcont(this.name, this.image, this.ipaddr, this.status);
}

class Continspect {
  var id;
  var image;
  var created;
  var startedtime;
  var finishedtime;
  var runtime;
  var ipaddr;
  Continspect(this.id, this.image, this.created, this.startedtime,
      this.finishedtime, this.runtime, this.ipaddr);
}
