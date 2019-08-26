import 'package:flutter/material.dart';
import 'package:lunarcalendar/ui/screens/sign_in_screen.dart';

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen();
  }
}
