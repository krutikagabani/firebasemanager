import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddStudentPage extends StatefulWidget {
  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _rollno = TextEditingController();
  TextEditingController _s1 = TextEditingController();
  TextEditingController _s2 = TextEditingController();
  TextEditingController _s3 = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Form(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    (file == null)
                        ? Image.asset(
                            "Image/student.jpg",
                            width: 350,
                            height: 150,
                          )
                        : Image.file(
                            file,
                            width: 350,
                            height: 150,
                          ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile pickedimage = await _picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                file = File(pickedimage.path);
                              });
                            },
                            child: Text("Camera"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile pickedimage = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                file = File(pickedimage.path);
                              });
                            },
                            child: Text("Gallery"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Name :",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _name,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your name",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Roll number :",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _rollno,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enyter your roll num",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Subject 1 :",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _s1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "sub 1",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Subject 2 :",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _s2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Sub 2",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Subject 3 :",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _s3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Sub 3",
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: ElevatedButton(
                              onPressed: () async {
                                var Name = _name.text.toString();
                                var Rollno = _rollno.text.toString();
                                var S1 = _s1.text.toString();
                                var S2 = _s2.text.toString();
                                var S3 = _s3.text.toString();
                                var Total = int.parse(S1) +
                                    int.parse(S2) +
                                    int.parse(S3);
                                var Percent = Total / 3;

                                var uuid = Uuid();
                                var filename = uuid.v1().toString() +
                                    ".jpg"; // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

                                await FirebaseStorage.instance
                                    .ref(filename)
                                    .putFile(file)
                                    .whenComplete(() {})
                                    .then((filedata) async {
                                  await filedata.ref
                                      .getDownloadURL()
                                      .then((fileurl) async {
                                    await FirebaseFirestore.instance
                                        .collection("Students")
                                        .add({
                                      "name": Name,
                                      "roll no": Rollno,
                                      "sub1": S1,
                                      "sub2": S2,
                                      "sub3": S3,
                                      "total": Total,
                                      "percentage": Percent,
                                      "fileurl": fileurl,
                                      "filename": filename,
                                    }).then((value) {
                                      setState(() {
                                        file = null;
                                      });
                                      _name.text = "";
                                      _rollno.text = "";
                                      _s1.text = "";
                                      _s2.text = "";
                                      _s3.text = "";
                                      Fluttertoast.showToast(
                                          msg: "Record inserted Successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 20.0);
                                    });
                                  });
                                });
                              },
                              child: Text("ADD"),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
