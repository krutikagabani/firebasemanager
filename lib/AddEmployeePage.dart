import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddEmployeePage extends StatefulWidget {
  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _email = TextEditingController();
  var _selectedGender = 'male';
  var select = "Purchase";

  ImagePicker _picker = ImagePicker();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Employees"),
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
              (file==null) ? Image.asset("Image/employee.jpg", width: 350, height: 150,):Image.file(file, width: 350,height: 150,),
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
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: ElevatedButton(
                      onPressed: () async {
                        var nm = _name.text.toString();
                        var mail = _email.text.toString();
                        var cont = _contact.text.toString();
                        var gender = _selectedGender.toString();
                        var Select = select.toString();

                        var uuid = Uuid();
                        var filename = uuid.v1().toString() + ".jpg";

                        await FirebaseStorage.instance.ref(filename).putFile(file).whenComplete(() {}).then((filedata) async {
                          await filedata.ref.getDownloadURL().then((fileurl) async {
                            await FirebaseFirestore.instance.collection("Employees").add({
                              "ename": nm,
                              "email": mail,
                              "econt": cont,
                              "selectgender": gender,
                              "select": Select,
                              "fileurl": fileurl,
                              "filename": filename,
                            }).then((value) {
                              setState(() {
                                file = null;
                              });
                              _name.text = "";
                              _email.text = "";
                              _contact.text = "";
                              _selectedGender = "";
                              // select = "";
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
            ]),
          ),
        ),
      ),
    );
  }
}
