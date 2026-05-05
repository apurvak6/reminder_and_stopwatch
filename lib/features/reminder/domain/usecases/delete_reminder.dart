import 'package:reminder_and_stopwatch/features/reminder/domain/repository/reminder_repository.dart';

class DeleteReminderUsecase {
  final ReminderRepository repository;
  DeleteReminderUsecase(this.repository);

  Future<void> call(String id) {
    return repository.deleteReminder(id);
  }
}
