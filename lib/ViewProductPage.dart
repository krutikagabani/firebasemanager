import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasemanager/UpdateProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ViewProductPage extends StatefulWidget {
  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Products"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Products").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(snapshot.hasData)
              {
                if(snapshot.data.size<=0)
                  {
                    return Center(child: Text("No Data"),);
                  }
                else
                  {
                    return ListView(
                      children: snapshot.data.docs.map((document){
                        // return ListTile(
                        //   title: Text(document["pname"].toString()),
                        //   subtitle: Text(document["pdesc"].toString()),
                        //   trailing: Text(document["sprice"].toString()),
                        //   onTap: () async {
                        //     var docid = document.id.toString();
                        //     await FirebaseFirestore.instance.collection("Products").doc(docid).delete();
                        //   },
                        // );

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 550.0,
                          color: Colors.amberAccent,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.network(document["fileurl"].toString(), width: 600,height: 300,),
                              Divider(),
                              Text(document["pname"].toString()),
                              Divider(),
                              Text(document["pdesc"].toString()),
                              Divider(),
                              Text(document["rprice"].toString()),
                              Divider(),
                              Text(document["sprice"].toString()),
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
                                    width:
                                    MediaQuery.of(context).size.width / 2.3,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          var docid = document.id.toString();
                                           var imagename = document["filename"].toString();
                                           await FirebaseStorage.instance.ref(imagename).delete().then((value) async {
                                            await FirebaseFirestore.instance.collection("Products").doc(docid).delete();
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
                                              MaterialPageRoute(builder: (context)=>UpdateProduct(docid: docid,))
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
