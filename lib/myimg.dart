import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'main.dart';

class MyImage extends StatefulWidget {
  const MyImage({Key? key}) : super(key: key);

  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  var myImageNamecontroller = TextEditingController();
  var myImageVersionController = TextEditingController();
  Future<List<Dimage>> getImages() async {
    final url = Uri.http("${Global.ip}:${Global.portno}", "/images/json");
    var response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(response.body);
    // print(result);
    List<Dimage> dimages = [];
    for (var u in result) {
      Dimage dimage = Dimage(u["RepoTags"][0], u["Containers"], u["Size"]);
      dimages.add(dimage);
    }
    // print(dimages.length);
    return dimages;
  }

  Future pullImage(imagename, tagname) async {
    // print(imagename);
    final url = Uri.http("${Global.ip}:${Global.portno}", "/images/create",
        {"fromImage": imagename, "tag": tagname});
    await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
  Future deleteImage(imagename) async {
    // print(imagename);
    final url =
        Uri.http("${Global.ip}:${Global.portno}", "/images/$imagename",{"force":"1"});
    
     await delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      }

  Future<List<Imageinspect>> inspectImage(imagename) async {
    // print(imagename);
    final url =
        Uri.http("${Global.ip}:${Global.portno}", "/images/$imagename/json");
    var response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(response.body);
    // print(result);
    // print(result["RepoTags"]);
    // print(result["Id"]);
    // print(result["Size"]);
    // print(result["Os"]);

    List<Imageinspect> imags = [];
    Imageinspect imag = Imageinspect(
        result["RepoTags"], result["Id"], result["Size"], result["Os"]);
    imags.add(imag);
    return imags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getImages(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: Text("Loading....")),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      horizontalTitleGap: 1,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                      title: Text(snapshot.data[index].name.toString()),
                      trailing: Text(
                          "${(snapshot.data[index].size / 1024 / 1024).round().toString()} MB"),
                          onLongPress: (){
                            deleteImage(snapshot.data[index].name.toString());
                          },
                      onTap: () async {
                        List<Imageinspect> b = await inspectImage(
                            snapshot.data[index].name.toString());
                            try{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Details'),
                                content: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Form(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Name: ${b[0].tags[0]}"),
                                        Text(
                                            "Size: ${(b[0].size / 1024 / 1024).round().toString()} MB"),
                                        Text("OS: ${b[0].author}"),
                                        Text("Id: ${b[0].id}"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });}catch(e){
                              print(e);
                            }
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: CircleAvatar(
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Pull an Image'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: myImageNamecontroller,
                                decoration: InputDecoration(
                                  labelText: 'Name of Image',
                                  icon: Icon(Icons.keyboard),
                                ),
                              ),
                              TextFormField(
                                controller: myImageVersionController,
                                decoration: InputDecoration(
                                  labelText: 'Tag Name',
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
                              pullImage(myImageNamecontroller.text,
                                  myImageVersionController.text);
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

class Dimage {
  var name;
  var cont;
  var size;
  Dimage(this.name, this.cont, this.size);
}

class Imageinspect {
  var tags;
  var id;
  var size;
  var author;
  Imageinspect(this.tags, this.id, this.size, this.author);
}
