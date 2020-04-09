import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Reminder {
  String id = Uuid().v4();
  ReminderMethod method;
  int count;
  ReminderType type;
  String time;

  Reminder({
    this.method = ReminderMethod.POPUP,
    this.count,
    this.type,
    this.time,
  });

  Reminder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        method = json['method'],
        count = json['count'],
        type = json['type'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method,
        'count': count,
        'type': type,
        'time': time,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LunarEvent) return false;

    return true && this.id == other.id;
  }
}

enum RepeatType { NO_REPEAT, MONTHLY, ANNUALLY }

enum ReminderMethod { POPUP, EMAIL }

enum ReminderType { DAY, WEEK }

class LunarEvent extends Comparable<LunarEvent> {
  String id = Uuid().v4();
  String summary;
  String start;
  String end;
  String location;
  int repeat;
  RepeatType repeatType;
  List<Reminder> reminders = [];

  LunarEvent(
      {this.summary,
      this.start,
      this.end,
      this.location,
      this.repeat,
      this.repeatType = RepeatType.ANNUALLY});

  LunarEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        summary = json['summary'],
        start = json['start'],
        end = json['end'],
        location = json['location'],
        repeat = json['repeat'],
        repeatType = json['repeatType'],
        reminders = json['reminders'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'summary': summary,
        'start': start,
        'end': end,
        'location': location,
        'repeat': repeat,
        'repeatType': repeatType,
        'reminders': reminders,
      };

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! LunarEvent) return false;

    return true && this.id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  int compareTo(LunarEvent other) {
    final formatter = DateFormat('MM-dd');
    var result =
        formatter.parse(this.start).compareTo(formatter.parse(other.start));
    if (result == 0) {
      return this.summary.compareTo(other.summary);
    }
    return result;
  }
}
