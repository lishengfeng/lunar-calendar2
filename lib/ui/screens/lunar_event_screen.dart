import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunarcalendar/models/lunar_event.dart';
import 'package:lunarcalendar/ui/screens/event_notification_screen.dart';

class LunarEventScreen extends StatefulWidget {
  final LunarEvent lunarEvent;

  LunarEventScreen({Key key, @required this.lunarEvent}) : super(key: key);

  @override
  _LunarEventScreenState createState() => _LunarEventScreenState();
}

class _LunarEventScreenState extends State<LunarEventScreen> {
  final _formKey = GlobalKey<FormState>();
  RepeatType _repeatType;
  List<Reminder> reminders;

  @override
  void initState() {
    _repeatType = widget.lunarEvent.repeatType;
    reminders = widget.lunarEvent.reminders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lunar Event'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g. mom\'s birthday',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.lunarEvent.summary,
                    onSaved: (String str) {
                      widget.lunarEvent.summary = str;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Event start date',
                      hintText: 'e.g. 01-31',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.lunarEvent.start,
                    keyboardType: TextInputType.datetime,
                    validator: (String str) {
                      if (!isValidDate(str)) {
                        return "Invalid date";
                      }
                      return null;
                    },
                    onSaved: (String str) {
                      widget.lunarEvent.start = str;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Event end date',
                      hintText: 'e.g. 01-31',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.lunarEvent.end,
                    keyboardType: TextInputType.datetime,
                    validator: (String str) {
                      if (!isValidDate(str)) {
                        return "Invalid date";
                      }
                      return null;
                    },
                    onSaved: (String str) {
                      widget.lunarEvent.end = str;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Repeat type:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: RepeatType.ANNUALLY,
                        groupValue: _repeatType,
                        onChanged: _handleRepeatTypeChange,
                      ),
                      Text(
                        'Annually',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Radio(
                        value: RepeatType.MONTHLY,
                        groupValue: _repeatType,
                        onChanged: _handleRepeatTypeChange,
                      ),
                      Text(
                        'Monthly',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Radio(
                        value: RepeatType.NO_REPEAT,
                        groupValue: _repeatType,
                        onChanged: _handleRepeatTypeChange,
                      ),
                      Text(
                        'No repeat',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Repeat times (1-99)',
                      hintText: 'e.g. 80',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.lunarEvent.repeat?.toString(),
                    keyboardType: TextInputType.number,
                    validator: (String val) {
                      if (!isInteger(val) || !isInRange(val, 1, 99)) {
                        return "Invalid number";
                      }
                      return null;
                    },
                    onSaved: (String str) {
                      widget.lunarEvent.repeat = int.parse(str.trim());
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Location (Optional)',
                      hintText:
                          'e.g. 1600 Amphitheatre Parkway Mountain View, CA',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.lunarEvent.location,
                    onSaved: (String str) {
                      widget.lunarEvent.location = str.trim();
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      if (widget.lunarEvent.reminders.length < 5)
                        MaterialButton(
                          onPressed: () {
                            _navigateToAddNotification(context);
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Icon(Icons.add, size: 12),
                          padding: EdgeInsets.all(6),
                          shape: CircleBorder(),
                          height: 5,
                          minWidth: 1,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final item = reminders[index];
                        return Card(
                          child: ListTile(
                            title: Text(getNotificationTitle(item)),
                            subtitle: Text(getNotificationSubtitle(item)),
                            trailing: MaterialButton(
                              onPressed: () {
                                reminders.removeAt(index);
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
                                      builder: (context) =>
                                          EventNotificationScreen(
                                            reminder: reminders[index],
                                          )));
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.pop(context, widget.lunarEvent);
                          }
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getNotificationTitle(Reminder reminder) {
    return reminder.method == ReminderMethod.POPUP ? 'Notification' : 'Email';
  }

  String getNotificationSubtitle(Reminder reminder) {
    return (reminder.count?.toString() ?? "1") +
        ' ' +
        (reminder.type == ReminderType.DAY ? "days" : "weeks") +
        ' before at ' +
        reminder.time;
  }

  bool isValidDate(str) {
    if (str == null || str.trim().isEmpty) return false;
    str = str.trim();
    try {
      final date = DateFormat('MM-dd').parse(str);
      final originalFormatString = toOriginalFormatDate(date);
      return str == originalFormatString;
    } catch (error) {
      return false;
    }
  }

  bool isInteger(str) {
    if (str == null || str.trim().isEmpty) return false;
    str = str.trim();
    try {
      final val = double.parse(str);
      return val == val.roundToDouble();
    } catch (error) {
      return false;
    }
  }

  bool isInRange(str, num min, num max) {
    if (str == null || str.trim().isEmpty) return false;
    str = str.trim();
    try {
      final dVal = double.parse(str);
      return dVal >= min && dVal <= max;
    } catch (error) {
      return false;
    }
  }

  String toOriginalFormatDate(DateTime dateTime) {
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$m-$d";
  }

  void _handleRepeatTypeChange(RepeatType value) {
    setState(() {
      _repeatType = value;
      widget.lunarEvent.repeatType = value;
    });
  }

  // A method that launches the EventNotificationScreen and awaits the
  // result from Navigator.pop.
  void _navigateToAddNotification(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventNotificationScreen(
                  reminder: new Reminder(),
                )));
    if (null != result) {
      this.reminders.add(result);
    }
  }
}
