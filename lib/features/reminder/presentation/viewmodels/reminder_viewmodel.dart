import 'package:flutter/foundation.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/repository/notification_repository.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/add_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/delete_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/sort_reminders.dart';

import '../../domain/entities/reminder.dart';
import '../../domain/usecases/get_reminders.dart';

class ReminderViewModel extends ChangeNotifier {
  final AddReminderUsecase addReminder;
  final DeleteReminderUsecase deleteReminder;
  final GetRemindersUsecase getReminders;
  final SortReminders sortReminders;
  final NotificationRepository notificationRepository;

  ReminderViewModel({
    required this.addReminder,
    required this.deleteReminder,
    required this.getReminders,
    required this.sortReminders,
    required this.notificationRepository,
  }) {
    loadReminders();
  }

  List<Reminder> reminders = [];
  bool isLoading = false;

  void loadReminders() {
    isLoading = true;
    notifyListeners();
    reminders = sortReminders(getReminders());
    isLoading = false;
    notifyListeners();
  }

  Future<void> add(Reminder reminder) async {
    await addReminder(reminder);

    await notificationRepository.schedule(reminder);

    reminders.add(reminder);
    reminders = sortReminders(reminders);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await deleteReminder(id);
    await notificationRepository.cancel(id);

    reminders.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  Future<void> toggleReminder(Reminder reminder, bool value) async {
    final updated = Reminder(
      id: reminder.id,
      title: reminder.title,
      time: reminder.time,
      isActive: value,
    );

    await addReminder(updated);

    if (value) {
      await notificationRepository.schedule(updated);
    } else {
      await notificationRepository.cancel(reminder.id);
    }

    final index = reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      reminders[index] = updated;
      notifyListeners();
    }
  }

  List<Reminder> getAll() {
    return getReminders();
  }
}
