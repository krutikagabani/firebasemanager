import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'UpdateEmployee.dart';

class ViewEmployeePage extends StatefulWidget {
  @override
  State<ViewEmployeePage> createState() => _ViewEmployeePageState();
}

class _ViewEmployeePageState extends State<ViewEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Employee list"),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("Employees").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.size <= 0) {
                return Center(
                  child: Text("No Data Found"),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 700.0,
                      color: Colors.amberAccent,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(
                            document["fileurl"].toString(),
                            width: 600,
                            height: 300,
                          ),
                          Divider(),
                          Text(document["ename"].toString()),
                          Divider(),
                          Text(document["email"].toString()),
                          Divider(),
                          Text(document["econt"].toString()),
                          Divider(),
                          Text(document["selectgender"].toString()),
                          Divider(),
                          Text(document["select"].toString()),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var docid = document.id.toString();
                                      var imagename = document["filename"].toString();
                                      await FirebaseStorage.instance.ref(imagename).delete().then((value) async {
                                        await FirebaseFirestore.instance.collection("Employees").doc(docid).delete();
                                      });

                                    }, child: Text("Delete")),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              Container(
                                width:
                                MediaQuery.of(context).size.width / 2.3,
                                child: ElevatedButton(
                                    onPressed: () {
                                      var docid = document.id.toString();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>UpdateEmployee(docid: docid,))
                                      );
                                    },
                                    child: Text("Update")),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
