import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preferences.dart';

class AddLunarEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lunar Event(Return to save)'),
        ),
        body: PreferencePage([
          TextFieldPreference(
            'Title',
            'summary',
            hintText: 'e.g. mom\'s birthday',
          ),
          TextFieldPreference(
            'Event start date (Lunar)',
            'event_start_date',
            hintText: 'e.g. 01/31/1990',
            validator: (String str) {
              if ((str?.isNotEmpty ?? false) && !isValidDate(str)) {
                return "Invalid date";
              }
              return null;
            },
          ),
          TextFieldPreference(
            'Event end date (Lunar)',
            'event_end_date',
            hintText: 'e.g. 01/31/1990',
            validator: (String str) {
              if ((str?.isNotEmpty ?? false) && !isValidDate(str)) {
                return "Invalid date";
              }
              return null;
            },
          ),
          PreferenceTitle('Repeat type'),
          RadioPreference(
            'Annually',
            'annually',
            'repeat_type',
            isDefault: true,
          ),
          RadioPreference('Monthly', 'monthly', 'repeat_type'),
          RadioPreference('Do not repeat', 'do_not_repeat', 'repeat_type'),
          TextFieldPreference(
            'Repeat times (1-99)',
            'repeat_times',
            hintText: 'e.g. 80',
            keyboardType: TextInputType.number,
            validator: (String val) {
              if ((val?.isNotEmpty ?? false) &&
                  (!isInteger(val) || !isInRange(val, 1, 99))) {
                return "Invalid number";
              }
              return null;
            },
          ),
          TextFieldPreference(
            'Location',
            'location',
            hintText: 'e.g. 1600 Amphitheatre Parkway Mountain View, CA',
          ),
          PreferenceTitle('Notifications'),
          PreferencePageLink(
            'Notification 1',
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([
              PreferenceTitle('Notification type'),
              RadioPreference('Email', 'email', 'notification_1'),
              RadioPreference('Notification', 'notification', 'notification_1'),
              TextFieldPreference(
                'days/weeks before',
                'day_or_week_1',
                hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                validator: (String str) {
                  if ((str?.isNotEmpty ?? false) && !isValidBefore(str)) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              TextFieldPreference(
                'Remind time (24-hour format)',
                'remind_time_1',
                hintText: 'e.g. 09:00',
                validator: (str) {
                  if ((str?.isNotEmpty ?? false) && !isValidTime(str)) {
                    return "Invalid time";
                  }
                  return null;
                },
              ),
            ]),
          ),
          PreferencePageLink(
            'Notification 2',
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([
              PreferenceTitle('Notification type'),
              RadioPreference('Email', 'email', 'notification_2'),
              RadioPreference('Notification', 'notification', 'notification_2'),
              TextFieldPreference(
                'days/weeks before',
                'day_or_week_2',
                hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                validator: (String str) {
                  if ((str?.isNotEmpty ?? false) && !isValidBefore(str)) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              TextFieldPreference(
                'Remind time (24-hour format)',
                'remind_time_2',
                hintText: 'e.g. 09:00',
                validator: (str) {
                  if ((str?.isNotEmpty ?? false) && !isValidTime(str)) {
                    return "Invalid time";
                  }
                  return null;
                },
              ),
            ]),
          ),
          PreferencePageLink(
            'Notification 3',
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([
              PreferenceTitle('Notification type'),
              RadioPreference('Email', 'email', 'notification_3'),
              RadioPreference('Notification', 'notification', 'notification_3'),
              TextFieldPreference(
                'days/weeks before',
                'day_or_week_3',
                hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                validator: (String str) {
                  if ((str?.isNotEmpty ?? false) && !isValidBefore(str)) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              TextFieldPreference(
                'Remind time (24-hour format)',
                'remind_time_3',
                hintText: 'e.g. 09:00',
                validator: (str) {
                  if ((str?.isNotEmpty ?? false) && !isValidTime(str)) {
                    return "Invalid time";
                  }
                  return null;
                },
              ),
            ]),
          ),
          PreferencePageLink(
            'Notification 4',
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([
              PreferenceTitle('Notification type'),
              RadioPreference('Email', 'email', 'notification_4'),
              RadioPreference('Notification', 'notification', 'notification_4'),
              TextFieldPreference(
                'days/weeks before',
                'day_or_week_4',
                hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                validator: (String str) {
                  if ((str?.isNotEmpty ?? false) && !isValidBefore(str)) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              TextFieldPreference(
                'Remind time (24-hour format)',
                'remind_time_4',
                hintText: 'e.g. 09:00',
                validator: (str) {
                  if ((str?.isNotEmpty ?? false) && !isValidTime(str)) {
                    return "Invalid time";
                  }
                  return null;
                },
              ),
            ]),
          ),
          PreferencePageLink(
            'Notification 5',
            leading: Icon(Icons.notifications),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([
              PreferenceTitle('Notification type'),
              RadioPreference('Email', 'email', 'notification_5'),
              RadioPreference('Notification', 'notification', 'notification_5'),
              TextFieldPreference(
                'days/weeks before',
                'day_or_week_5',
                hintText: 'e.g. 1d (1-27) or 1w (1-3)',
                validator: (String str) {
                  if ((str?.isNotEmpty ?? false) && !isValidBefore(str)) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              TextFieldPreference(
                'Remind time (24-hour format)',
                'remind_time_5',
                hintText: 'e.g. 09:00',
                validator: (str) {
                  if ((str?.isNotEmpty ?? false) && !isValidTime(str)) {
                    return "Invalid time";
                  }
                  return null;
                },
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  bool isValidDate(str) {
    try {
      final date = DateFormat('MM/dd/yyyy').parse(str);
      final originalFormatString = toOriginalFormatDate(date);
      return str == originalFormatString;
    } catch (error) {
      return false;
    }
  }

  String toOriginalFormatDate(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0').substring(0, 4);
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$m/$d/$y";
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

  bool isValidBefore(String str) {
    if (str == "") return true;
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

  bool isValidTime(str) {
    if (str == "") return true;
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
}
