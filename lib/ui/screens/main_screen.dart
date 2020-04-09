// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lunarcalendar/models/lunar_event.dart';
import 'package:lunarcalendar/ui/screens/lunar_event_screen.dart';
import 'package:lunarcalendar/utils/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sorted_list/sorted_list.dart';

// This app is a stateful, it tracks the user's current choice.
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SortedList<LunarEvent> lunarEvents;
  ProgressDialog pr;

  void _select(Choice choice) {
    switch (choice.title) {
      case 'Import':
        loadCalendars().then((Map<String, String> map) {
          if (map.length == 0) {
            Fluttertoast.showToast(
              msg: "There is no calendar found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Choose an existing lunar calendar'),
                    children: map.entries.map<SimpleDialogOption>((entry) {
                      return SimpleDialogOption(
                        child: Text(entry.key),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      );
                    }).toList(),
                  );
                });
          }
        }).catchError((e) {
          Fluttertoast.showToast(
            msg: "Got error: ${e.error}.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        });
        break;
      case 'Export':
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    lunarEvents = new SortedList((a, b) => a.compareTo(b));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lunar Calendar'),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              // overflow menu
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                var list = List<PopupMenuEntry<Choice>>();
                choices.asMap().forEach((index, choice) {
                  list.add(PopupMenuItem<Choice>(
                    value: choice,
                    child: ListTile(
                      leading: Icon(choice.icon),
                      title: Text(choice.title),
                    ),
                  ));
                  if (index != choices.length - 1) {
                    list.add(PopupMenuDivider(
                      height: 5,
                    ));
                  }
                });
                return list;
              },
            ),
          ],
        ),
        body: Container(
          child: _buildContent(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddLunarEvent(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (lunarEvents.length == 0) {
      return new Center(
        child: Text('You do not have any events yet. Please try to add some.'),
      );
    } else {
      return ListView.builder(
          itemCount: lunarEvents.length,
          itemBuilder: (context, index) {
            final item = lunarEvents[index];
            return Card(
              child: ListTile(
                title: Text(item.summary),
                subtitle: Text(item.start + ' to ' + item.end),
                trailing: MaterialButton(
                  onPressed: () {
                    lunarEvents.removeAt(index);
                    setState(() {});
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Icon(Icons.remove, size: 12),
                  padding: EdgeInsets.all(6),
                  shape: CircleBorder(),
                  height: 5,
                  minWidth: 1,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LunarEventScreen(
                                lunarEvent: lunarEvents[index],
                              )));
                },
              ),
            );
          });
    }
  }

  void _navigateToAddLunarEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LunarEventScreen(
                lunarEvent: new LunarEvent(),
              )),
    );
    if (null != result) {
      lunarEvents.add(result);
      setState(() {});
    }
  }

  Future<Map<String, String>> loadCalendars() async {
    pr.show();
    if (googleSignIn.currentUser == null) {
      await googleSignIn.signInSilently();
    }
    final http.Response response = await http.get(
        'https://www.googleapis.com/calendar/v3/users/me/calendarList',
        headers: await googleSignIn.currentUser.authHeaders);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
        msg: "Google Calenndar API gave a ${response.statusCode} response.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      pr.hide();
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final Map<String, String> calendarSummaryIdMap = Map.fromIterable(
        data['items'],
        key: (v) => v['summary'],
        value: (v) => v['id']);
    pr.hide();
    return calendarSummaryIdMap;
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Import', icon: Icons.cloud_download),
  Choice(title: 'Export', icon: Icons.backup),
];
