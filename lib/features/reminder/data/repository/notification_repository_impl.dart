import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:reminder_and_stopwatch/core/services/notification_service.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/entities/reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<void> cancel(String id) {
    return NotificationService.cancel(id);
  }

  @override
  Future<void> schedule(Reminder r) {
    return NotificationService.scheduleNotification(
      id: r.id,
      title: r.title,
      time: r.time,
    );
  }
}
