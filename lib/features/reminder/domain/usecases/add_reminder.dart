import 'package:reminder_and_stopwatch/features/reminder/domain/repository/reminder_repository.dart';

import '../entities/reminder.dart';

class AddReminderUsecase {
  final ReminderRepository repository;

  AddReminderUsecase(this.repository);

  ///call method from abstract repository in use case
  Future<void> call(Reminder reminder) {
    return repository.addReminder(reminder);
  }
}
