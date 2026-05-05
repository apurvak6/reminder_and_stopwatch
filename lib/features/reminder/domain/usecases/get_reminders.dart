import '../entities/reminder.dart';
import '../repository/reminder_repository.dart';

class GetRemindersUsecase {
  final ReminderRepository repository;

  GetRemindersUsecase(this.repository);

  ///call method from abstract repository in use case
  List<Reminder> call() {
    return repository.getReminders();
  }
}
