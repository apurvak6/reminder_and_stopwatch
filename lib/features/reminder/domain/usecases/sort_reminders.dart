import 'package:reminder_and_stopwatch/features/reminder/domain/entities/reminder.dart';

class SortReminders {
  List<Reminder> call(List<Reminder> list) {
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }
}
