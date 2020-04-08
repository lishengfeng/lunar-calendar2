import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunarcalendar/models/lunar_event.dart';

class EventNotificationScreen extends StatefulWidget {
  Reminder reminder;

  EventNotificationScreen({Key key, this.reminder}) : super(key: key);

  @override
  _EventNotificationScreenState createState() =>
      _EventNotificationScreenState();
}

class _EventNotificationScreenState extends State<EventNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  ReminderMethod _reminderMethod;

  @override
  void initState() {
    if (widget.reminder == null) {
      widget.reminder = new Reminder();
    }
    _reminderMethod = widget.reminder.method ?? ReminderMethod.EMAIL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notification'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Notification type:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: ReminderMethod.EMAIL,
                        groupValue: _reminderMethod,
                        onChanged: _handleReminderMethodChange,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Radio(
                        value: ReminderMethod.POP_UP,
                        groupValue: _reminderMethod,
                        onChanged: _handleReminderMethodChange,
                      ),
                      Text(
                        'Notification',
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
                      labelText: 'days/weeks before',
                      hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: getDaysOrWeeksBeforeText(widget.reminder),
                    validator: (String str) {
                      if (!isValidBefore(str)) {
                        return "Invalid value";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Remind time (24-hour format)',
                      hintText: 'e.g. 09:00',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.reminder.time,
                    keyboardType: TextInputType.datetime,
                    validator: (String str) {
                      if (!isValidTime(str)) {
                        return "Invalid time";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleReminderMethodChange(ReminderMethod value) {
    setState(() {
      _reminderMethod = value;
    });
  }

  bool isValidTime(str) {
    if (str == null || str.trim().isEmpty) return false;
    str = str.trim();
    try {
      final time = DateFormat('HH:mm').parse(str);
      final originalFormatString = toOriginalFormatTime(time);
      return str == originalFormatString;
    } catch (error) {
      return false;
    }
  }

  String toOriginalFormatTime(DateTime dateTime) {
    final h = dateTime.hour.toString().padLeft(2, '0').substring(0, 2);
    final m = dateTime.minute.toString().padLeft(2, '0').substring(0, 2);
    return "$h:$m";
  }

  bool isValidBefore(String str) {
    if (str == null || str.trim().isEmpty) return false;
    str = str.trim();
    final type = str.substring(str.length - 1);
    if (type != 'd' && type != 'w') return false;
    final strNum = str.substring(0, str.length - 1);
    if (!isInteger(strNum)) return false;
    if (type == 'd') {
      return isInRange(strNum, 1, 27);
    } else {
      return isInRange(strNum, 1, 3);
    }
  }

  bool isInteger(str) {
    try {
      final val = double.parse(str);
      return val == val.roundToDouble();
    } catch (error) {
      return false;
    }
  }

  bool isInRange(val, num min, num max) {
    try {
      final dVal = double.parse(val);
      return dVal >= min && dVal <= max;
    } catch (error) {
      return false;
    }
  }

  String getDaysOrWeeksBeforeText(Reminder reminder) {
    return reminder.count.toString() +
        (reminder.type == ReminderType.DAY ? 'd' : 'w');
  }
}
