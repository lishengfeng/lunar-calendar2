import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import "package:lunarcalendar/models/walkthrough.dart";
import 'package:lunarcalendar/ui/widgets/custom_flat_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final List<Walkthrough> pages = [
    Walkthrough(
      icon: Icons.calendar_today,
      title: "Welcome to the App!",
      description:
          "Just getting start? Let\'s take a look at some great feature of this app.",
    ),
    Walkthrough(
      icon: Icons.add_alarm,
      title: "Add a lunar event",
      description:
          "Adding lunar event is quite simple. Just like adding an event in Google Calendar.",
    ),
    Walkthrough(
      icon: Icons.sync,
      title: "Sync to Google Calendar",
      description:
          "This app will automatically convert your lunar event to solar event and sync them to your Google Calendar.",
    ),
    Walkthrough(
      icon: Icons.sentiment_very_satisfied,
      title: "Reinstall app?",
      description:
          "Just import your lunar events from your Google Calendar back to app. You will retrieve all your inputs w/o retyping again.",
    ),
  ];

  WalkthroughScreen({this.prefs});

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.white30,
              activeColor: Colors.white,
              size: 6.5,
              activeSize: 8.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context),
      ),
    );
  }

  List<Widget> _getPages(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      Walkthrough page = widget.pages[i];
      widgets.add(
        new Container(
          color: Color(0xFF0096a6),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Icon(
                  page.icon,
                  size: 125.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
                  page.title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  page.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: i != widget.pages.length - 1
                    ? Container()
                    : Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 15.0, left: 15.0),
                                child: CustomFlatButton(
                                  title: "Get Started",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    widget.prefs.setBool('seen', true);
                                    Navigator.of(context).pushNamed("/root");
                                  },
                                  splashColor: Colors.black12,
                                  borderColor: Colors.white,
                                  borderWidth: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
