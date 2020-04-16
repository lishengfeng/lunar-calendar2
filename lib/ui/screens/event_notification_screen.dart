import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunarcalendar/models/lunar_event.dart';
import 'package:lunarcalendar/utils/demo_localizations.dart';

class EventNotificationScreen extends StatefulWidget {
  final Reminder reminder;

  EventNotificationScreen({Key key, @required this.reminder}) : super(key: key);

  @override
  _EventNotificationScreenState createState() =>
      _EventNotificationScreenState();
}

class _EventNotificationScreenState extends State<EventNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  ReminderMethod _reminderMethod;

  @override
  void initState() {
    _reminderMethod = widget.reminder.method;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(DemoLocalizations.of(context)
              .localizedValues['notification_title']),
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
                    DemoLocalizations.of(context)
                        .localizedValues['notification_type'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: ReminderMethod.POPUP,
                        groupValue: _reminderMethod,
                        onChanged: _handleReminderMethodChange,
                      ),
                      Text(
                        DemoLocalizations.of(context)
                            .localizedValues['calendar_reminder_notification'],
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Radio(
                        value: ReminderMethod.EMAIL,
                        groupValue: _reminderMethod,
                        onChanged: _handleReminderMethodChange,
                      ),
                      Text(
                        DemoLocalizations.of(context)
                            .localizedValues['calendar_reminder_email'],
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
                    decoration: InputDecoration(
                      labelText: DemoLocalizations.of(context)
                          .localizedValues['notification_days_weeks_before'],
                      hintText: DemoLocalizations.of(context).localizedValues[
                          'notification_days_weeks_before_hint'],
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: getDaysOrWeeksBeforeText(widget.reminder),
                    validator: (String str) {
                      if (!isValidBefore(str)) {
                        return DemoLocalizations.of(context)
                            .localizedValues['invalid_value'];
                      }
                      return null;
                    },
                    onSaved: saveDaysOrWeeksBefore,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: DemoLocalizations.of(context)
                          .localizedValues['notification_remind_time'],
                      hintText: DemoLocalizations.of(context)
                          .localizedValues['notification_remind_time_hint'],
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0), //Control height
                    ),
                    initialValue: widget.reminder.time,
                    keyboardType: TextInputType.datetime,
                    validator: (String str) {
                      if (!isValidTime(str)) {
                        return DemoLocalizations.of(context)
                            .localizedValues['invalid_time'];
                      }
                      return null;
                    },
                    onSaved: (String str) {
                      widget.reminder.time = str;
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
                            _formKey.currentState.save();
                            widget.reminder.method = _reminderMethod;
                            Navigator.pop(context, widget.reminder);
                          }
                        },
                        child: Text(DemoLocalizations.of(context)
                            .localizedValues['save']),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(DemoLocalizations.of(context)
                            .localizedValues['cancel']),
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
    if (null == reminder.count || null == reminder.type) return null;
    return reminder.count.toString() +
        (reminder.type == ReminderType.DAY ? 'd' : 'w');
  }

  void saveDaysOrWeeksBefore(String str) {
    str = str.trim();
    final type = str.substring(str.length - 1);
    final strNum = str.substring(0, str.length - 1);
    final count = int.parse(strNum);
    widget.reminder.count = count;
    widget.reminder.type = type == 'd' ? ReminderType.DAY : ReminderType.WEEK;
  }
}
