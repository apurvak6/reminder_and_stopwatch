import 'package:hive/hive.dart';
import '../../features/reminder/data/model/reminder_model.dart';

class HiveService {
  static const boxName = 'reminders';

  static Future<void> addReminder(ReminderModel reminder) async {
    final box = Hive.box<ReminderModel>(boxName);
    await box.put(reminder.id, reminder);
  }

  static List<ReminderModel> getReminders() {
    final box = Hive.box<ReminderModel>(boxName);
    return box.values.toList();
  }

  static Future<void> deleteReminder(String id) async {
    final box = Hive.box<ReminderModel>(boxName);
    await box.delete(id);
  }
}
