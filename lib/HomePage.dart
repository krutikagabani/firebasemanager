import 'package:firebasemanager/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var name = "";
  var email = "";
  var photo = "";
  var googleid = "";

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      photo = prefs.getString("photo");
      googleid = prefs.getString("googleid");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child:Container(
            width: MediaQuery.of(context).size.width,
            height: 500,
            color: Color(0xFFe3f2fd ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "name :" + name,
                  style: TextStyle(fontSize: 20, color: Color(0xFF1a237e)),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color:  Color(0xFF90caf9),
                ),
                Text(
                  "email :" + email,
                  style: TextStyle(fontSize: 20, color: Color(0xFF1a237e)),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color: Color(0xFF90caf9),
                ),
                Text(
                  "photo :" + photo,
                  style: TextStyle(fontSize: 20, color: Color(0xFF1a237e)),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color: Color(0xFF90caf9),
                ),
                Text(
                  "googleid :" + googleid,
                  style: TextStyle(fontSize: 20, color: Color(0xFF1a237e)),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color: Color(0xFF90caf9),
                ),
                SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.remove("islogin");

                    GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.signOut();


                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FirebaseAuthentication()));
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
