import 'package:flutter/material.dart';
import 'package:lunarcalendar/ui/screens/sign_in_screen.dart';
import 'package:lunarcalendar/ui/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootScreen extends StatelessWidget {
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
            return MainScreen(
//              firebaseUser: snapshot.data,
            );
          } else {
            return SignInScreen();
          }
        }
      },
    );
  }
}
