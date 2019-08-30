import 'package:flutter/material.dart';
import 'package:lunarcalendar/ui/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
//            return new MainScreen(
//              firebaseUser: snapshot.data,
//            );
            return Container(
              child: Text("You've already signed in."),
            );
          } else {
            return SignInScreen();
          }
        }
      },
    );
  }
}
