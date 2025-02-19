import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunarcalendar/ui/screens/main_screen.dart';
import 'package:lunarcalendar/utils/auth.dart';
import 'package:lunarcalendar/utils/demo_localizations.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DemoLocalizations.of(context).localizedValues['welcome'],
                style: Theme.of(context).textTheme.headline,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/lunar_icon.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: Icon(
                            Icons.sync,
                            size: 50.0,
                            color: Colors.blue,
                          ),
                          flex: 1,
                        ),
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/google_calendar_icon.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Center(
                      child: Text(
                        DemoLocalizations.of(context).localizedValues['sign_in_requirement_desc'],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline,
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    _signInButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((bool success) {
          if (success) {
            Navigator.of(context).pushNamedAndRemoveUntil("/root", (r) => false);
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                DemoLocalizations.of(context).localizedValues['sign_in_with_google'],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
