import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasemanager/UpdateStudent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ViewStudentsPage extends StatefulWidget {
  @override
  State<ViewStudentsPage> createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View students details"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Students").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(snapshot.hasData)
            {
              if(snapshot.data.size<=0)
              {
                return Center(child: Text("No Data Found"),);
              }
              else
              {
                return ListView(
                  children: snapshot.data.docs.map((document){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 700.0,
                      color: Colors.amberAccent,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.network(document["fileurl"].toString(), width: 600,height: 300,),
                          Divider(),
                          Text(document["name"].toString()),
                          Divider(),
                          Text(document["roll no"].toString()),
                          Divider(),
                          Text(document["sub1"].toString()),
                          Divider(),
                          Text(document["sub2"].toString()),
                          Divider(),
                          Text(document["sub3"].toString()),
                          Divider(),
                          Text(document["total"].toString()),
                          Divider(),
                          Text(document["percentage"].toString()),
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
                                        await FirebaseFirestore.instance.collection("Students").doc(docid).delete();
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
                                          MaterialPageRoute(builder: (context)=>UpdateStudent(docid: docid,))
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
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}
