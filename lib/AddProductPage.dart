import 'dart:io';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:uuid/uuid.dart';

  class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
  }

  class _AddProductPageState extends State<AddProductPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _rprice = TextEditingController();
  TextEditingController _sprice = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File file;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Add Products"),
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
  "Image/1.jpg",
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
  onPressed: () async
  {
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
  "Description :",
  style: TextStyle(fontSize: 20),
  ),
  SizedBox(
  height: 10,
  ),
  TextFormField(
  controller: _desc,
  keyboardType: TextInputType.text,
  decoration: InputDecoration(
  border: OutlineInputBorder(),
  hintText: "Product Description",
  ),
  maxLines: 5,
  ),
  SizedBox(
  height: 20,
  ),
  Text(
  "R price :",
  style: TextStyle(fontSize: 20),
  ),
  SizedBox(
  height: 10,
  ),
  TextFormField(
  controller: _rprice,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
  border: OutlineInputBorder(),
  hintText: "R price",
  ),
  ),
  SizedBox(
  height: 20,
  ),
  Text(
  "S price :",
  style: TextStyle(fontSize: 20),
  ),
  SizedBox(
  height: 10,
  ),
  TextFormField(
  controller: _sprice,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
  border: OutlineInputBorder(),
  hintText: "S price",
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
  var name = _name.text.toString();
  var pdesc = _desc.text.toString();
  var rprice = _rprice.text.toString();
  var sprice = _sprice.text.toString();

  var uuid = Uuid();
  var filename = uuid.v1().toString() + ".jpg";

  await FirebaseStorage.instance
      .ref(filename)
      .putFile(file)
      .whenComplete(() {})
      .then((filedata) async {
  await filedata.ref
      .getDownloadURL()
      .then((fileurl) async {
  await FirebaseFirestore.instance
      .collection("Products")
      .add({
  "pname": name,
  "pdesc": pdesc,
  "rprice": rprice,
  "sprice": sprice,
  "fileurl": fileurl,
  "filename": filename,
  }).then((value) {
  setState(() {
  file = null;
  });
  _name.text = "";
  _desc.text = "";
  _rprice.text = "";
  _sprice.text = "";

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
  ));
  }
}
