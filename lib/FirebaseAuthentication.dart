import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasemanager/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthentication extends StatefulWidget {

  @override
  State<FirebaseAuthentication> createState() => _FirebaseAuthenticationState();
}

class _FirebaseAuthenticationState extends State<FirebaseAuthentication> {
  checklogin() async
  {
    GoogleSignIn googleSignIn = GoogleSignIn();
    if(await googleSignIn.isSignedIn())
    {
      Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage())
        );
    }
    // SharedPreferences prefs =
    // await SharedPreferences.getInstance();
    // if(prefs.containsKey("islogin"))
    // {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => HomePage())
    //   );
    // }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }


  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Center(
          child: ElevatedButton(
            onPressed: () async{
                final GoogleSignIn googleSignIn = GoogleSignIn();
                final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                if (googleSignInAccount != null) {
                  final GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;
                  final AuthCredential authCredential = GoogleAuthProvider
                      .credential(
                      idToken: googleSignInAuthentication.idToken,
                      accessToken: googleSignInAuthentication.accessToken);

                  // Getting users credential
                  UserCredential result = await auth.signInWithCredential(
                      authCredential);
                  User user = result.user;

                  var name  = user.displayName.toString();
                  var email = user.email.toString();
                  var photo = user.photoURL.toString();
                  var googleid = user.uid.toString();

                  print("name : "+name);
                  print("email : "+email);
                  print("photo : "+photo);
                  print("googleid : "+googleid);

                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString("name", name);
                  prefs.setString("email", email);
                  prefs.setString("photo", photo);
                  prefs.setString("googleid", googleid);
                  prefs.setString("islogin", "yes");

                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage())
                  );


                }

            },
            child: Text("Login With Google",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ),
      ),
    );
  }
}
