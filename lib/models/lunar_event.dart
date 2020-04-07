import 'package:uuid/uuid.dart';
import 'dart:collection';

class Reminder {
  String method = "popup";
  var count = 1;
  String type = "days";
  String time = "09:00";
}

enum RepeatType { NO_REPEAT, MONTHLY, ANNUALLY }

enum ReminderMethod {POP_UP, EMAIL}

class LunarEvent {
  final Uuid id = Uuid();
  String summary = "";
  String start = "01-01";
  String end = "01-01";
  String location;
  int repeat = 0;
  RepeatType repeatType = RepeatType.ANNUALLY;
  final SplayTreeMap<int, Reminder> reminderMap = new SplayTreeMap();

  LunarEvent({this.summary,
    this.start,
    this.end,
    this.location,
    this.repeat,
    this.repeatType});

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LunarEvent) return false;

    return true &&
        this.id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
