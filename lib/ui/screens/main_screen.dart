// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// This app is a stateful, it tracks the user's current choice.
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Choice _selectedChoice = choices[0]; // The app's "state".
  List<String> items = [];

  void _select(Choice choice) {
    setState(() { // Causes the app to rebuild with the new _selectedChoice.
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lunar Calendar'),
          actions: <Widget>[
            PopupMenuButton<Choice>( // overflow menu
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(0).map<PopupMenuItem<Choice>>((
                    Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Container(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (items.length == 0) {
      return new Center(
          child: Text('You do not have any events yet. Please try to add some.'),
      );
    } else {
      return new Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChoiceCard(choice: _selectedChoice),
      );
    }
  }
}

class Choice {
  const Choice({ this.title, this.icon });

  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Import', icon: Icons.import_export),
  Choice(title: 'Export', icon: Icons.import_export),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .headline;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
