import 'package:flutter/material.dart';

class GoogleMapExample extends StatefulWidget {

  @override
  State<GoogleMapExample> createState() => _GoogleMapExampleState();
}

class _GoogleMapExampleState extends State<GoogleMapExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google map"),
      ),
    );
  }
}
