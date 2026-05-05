import 'package:hive/hive.dart';
import 'package:reminder_and_stopwatch/features/reminder/data/model/reminder_model.dart';

class ReminderLocalDatasource {
  final box = Hive.box<ReminderModel>('reminders');

  Future<void> add(ReminderModel reminder) async {
    await box.put(reminder.id, reminder);
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }

  List<ReminderModel> getAll() {
    return box.values.toList();
  }
}
