import 'package:reminder_and_stopwatch/features/reminder/data/datasource/reminder_local_datasource.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/repository/reminder_repository.dart';

import '../../domain/entities/reminder.dart';
import '../model/reminder_model.dart';

class ReminderRepositoryImpl extends ReminderRepository {
  final ReminderLocalDatasource local;

  ReminderRepositoryImpl(this.local);

  @override
  Future<void> addReminder(Reminder reminder) async {
    final model = ReminderModel.fromEntity(reminder);
    //   id: reminder.id,
    //   time: reminder.time,
    //   title: reminder.title,
    //   isActive: reminder.isActive,
    // );

    await local.add(model);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await local.delete(id);
  }

  @override
  List<Reminder> getReminders() {
    return local
        .getAll()
        .map(
          (e) => e.toEntity(),
          //     Reminder(
          //   id: e.id,
          //   time: e.time,
          //   title: e.title,
          //   isActive: e.isActive,
          // ),
        )
        .toList();
  }
}
