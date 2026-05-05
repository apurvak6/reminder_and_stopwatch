import 'package:reminder_and_stopwatch/features/reminder/domain/entities/reminder.dart';

abstract class NotificationRepository {
  Future<void> schedule(Reminder r);
  Future<void> cancel(String id);
}
