import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/repository/notification_repository.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/add_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/delete_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/sort_reminders.dart';

import '../../../../core/services/notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/get_reminders.dart';

class ReminderController extends GetxController {
  final AddReminderUsecase addReminder;
  final DeleteReminderUsecase deleteReminder;
  final GetRemindersUsecase getReminders;
  final SortReminders sortReminders;
  final NotificationRepository notificationRepository;

  ReminderController({
    required this.addReminder,
    required this.deleteReminder,
    required this.getReminders,
    required this.sortReminders,
    required this.notificationRepository,
  });

  var reminders = <Reminder>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  void loadReminders() {
    isLoading.value = true;
    reminders.value = sortReminders(getReminders());
    isLoading.value = false;
  }

  Future<void> add(Reminder reminder) async {
    await addReminder(reminder);

    await notificationRepository.schedule(reminder);

    reminders.add(reminder);
    reminders.value = sortReminders(reminders);
  }

  Future<void> delete(String id) async {
    await deleteReminder(id);
    await notificationRepository.cancel(id);

    reminders.removeWhere((r) => r.id == id);
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
      reminders.refresh();
    }
  }

  List<Reminder> getAll() {
    return getReminders();
  }
}
