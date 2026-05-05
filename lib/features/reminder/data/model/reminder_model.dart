import 'package:hive/hive.dart';

import '../../domain/entities/reminder.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 0)
class ReminderModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final bool isActive;

  ReminderModel({
    required this.id,
    required this.time,
    required this.title,
    this.isActive = true,
  });

  factory ReminderModel.fromEntity(Reminder e) => ReminderModel(
    id: e.id,
    time: e.time,
    title: e.title,
    isActive: e.isActive,
  );

  Reminder toEntity() =>
      Reminder(id: id, time: time, title: title, isActive: isActive);
}
