import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Reminder {
  final Uuid id = Uuid();
  ReminderMethod method = ReminderMethod.POP_UP;
  var count = 1;
  ReminderType type = ReminderType.DAY;
  String time = "09:00";

  Reminder({
    this.method,
    this.count,
    this.type,
    this.time,
  });

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

enum ReminderMethod { POP_UP, EMAIL }

enum ReminderType { DAY, WEEK }

class LunarEvent extends Comparable<LunarEvent> {
  final Uuid id = Uuid();
  String summary;
  String start;
  String end;
  String location;
  int repeat;
  RepeatType repeatType = RepeatType.ANNUALLY;
  final List<Reminder> reminders = [];

  LunarEvent(
      {this.summary,
      this.start,
      this.end,
      this.location,
      this.repeat,
      this.repeatType});

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
    final formatter = DateFormat('MM/dd/yyyy');
    var result =
        formatter.parse(this.start).compareTo(formatter.parse(other.start));
    if (result == 0) {
      return this.summary.compareTo(other.summary);
    }
    return result;
  }

  void addReminder(Reminder reminder) {
    this.reminders.add(reminder);
  }

  void removeReminder(Reminder reminder) {
    reminders.remove(reminder);
  }
}
