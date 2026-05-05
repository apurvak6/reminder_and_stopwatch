class Reminder {
  final String id;
  final DateTime time;
  final String title;
  final bool isActive;

  Reminder({
    required this.id,
    required this.time,
    required this.title,
    this.isActive = true,
  });
}
