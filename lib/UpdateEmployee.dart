import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateEmployee extends StatefulWidget {

  var docid;
  UpdateEmployee({this.docid});

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _email = TextEditingController();
  var _selectedGender = 'male';
  var select = "Purchase";

  var oldfilename="";
  var cloudimageurl="";

  ImagePicker _picker = ImagePicker();
  File file;

  getsingledata() async
  {
    await FirebaseFirestore.instance.collection("Employees").doc(widget.docid).get().then((document){
      setState(() {
        _name.text = document["ename"].toString();
        _contact.text = document["email"].toString();
        _email.text = document["econt"].toString();
        _selectedGender = document["selectgender"].toString();
        select = document["select"].toString();

        oldfilename= document["filename"].toString();
        cloudimageurl= document["fileurl"].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsingledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Employees"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 20,
              ),
              (file==null)?
              (cloudimageurl!="")
                  ?Image.network(cloudimageurl,width: 350.0,height: 150.0)
                  :CircularProgressIndicator()
                  :Image.file(file,width: 350.0,height: 150.0),
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
                "Contact :",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _contact,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your Contact number",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Email :",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your Email",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Gender :",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                    activeColor: Colors.green,
                    value: 'male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  Text('Male', style: TextStyle(fontSize: 20)),
                  Radio(
                    activeColor: Colors.green,
                    value: 'female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  Text('Female', style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Department :",
                    style: TextStyle(fontSize: 20),
                  ),
                  DropdownButton(
                    value: select,
                    onChanged: (val) {
                      // print("val : "+val);
                      setState(() {
                        select = val;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "Purchase Department",
                          style: TextStyle(fontSize: 17),
                        ),
                        value: "Purchase",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Sales Department",
                          style: TextStyle(fontSize: 17),
                        ),
                        value: "Sales",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Accounting Department",
                          style: TextStyle(fontSize: 17),
                        ),
                        value: "Accounting",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Marketing Department",
                          style: TextStyle(fontSize: 17),
                        ),
                        value: "Marketing",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "Technical Department",
                          style: TextStyle(fontSize: 17),
                        ),
                        value: "Technical",
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.2,
                    child: ElevatedButton(
                      onPressed: () async{
                        var ename = _name.text.toString();
                        var email = _contact.text.toString();
                        var econt = _email.text.toString();
                        var selectgender = _selectedGender.toString();

                        if(file==null)
                        {
                          await FirebaseFirestore.instance.collection("Employees").doc(widget.docid).update({
                            "ename":ename,
                            "email":email,
                            "econt":econt,
                            "selectgender":selectgender,
                            "select":select,
                          }).then((value){
                            setState(() {
                              file=null;
                            });
                            _name.text="";
                            _contact.text="";
                            _email.text="";
                            _selectedGender="";


                            Fluttertoast.showToast(
                                msg: "Product Updated Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          });
                          Navigator.of(context).pop();
                        }
                        else
                        {
                          await FirebaseStorage.instance.ref(oldfilename).delete().then((value) async{
                            var uuid = Uuid();
                            var filename = uuid.v1().toString()+".jpg"; //6c84fb90-12c4-11e1-840d-7b25c5ee775a.jpg

                            await FirebaseStorage.instance.ref(filename).putFile(file).whenComplete((){}).then((filedata) async{
                              await filedata.ref.getDownloadURL().then((fileurl) async{

                                await FirebaseFirestore.instance.collection("Employees").doc(widget.docid).update({
                                  "ename":ename,
                                  "email":email,
                                  "econt":econt,
                                  "selectgender":selectgender,
                                  "select":select,
                                  "fileurl":fileurl,
                                  "filename":filename
                                }).then((value){
                                  setState(() {
                                    file=null;
                                  });
                                  _name.text="";
                                  _contact.text="";
                                  _email.text="";
                                  _selectedGender="";
                                  Fluttertoast.showToast(
                                      msg: "Product Updated Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                });
                                Navigator.of(context).pop();
                              });
                            });
                          });
                        }
                      },
                      child: Text("Update",style: TextStyle(fontSize: 20),),
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
            ]),
          ),
        ),
      ),
    );
  }
}

