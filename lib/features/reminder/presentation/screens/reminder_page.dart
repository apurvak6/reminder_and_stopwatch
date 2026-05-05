import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/reminder.dart';
import '../viewmodels/reminder_viewmodel.dart';

class ReminderPage extends StatelessWidget {
  ReminderPage({super.key});

  /// ADD REMINDER UI (Bottom Sheet)
  void _showAddReminderSheet(BuildContext context) {
    final viewModel = context.read<ReminderViewModel>();
    final titleController = TextEditingController();
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Reminder",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.alarm_add, color: Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Title input
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Time picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime == null
                            ? "Select Time"
                            : selectedTime!.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            setState(() => selectedTime = time);
                          }
                        },
                        child: const Text("Pick Time"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter title & time")),
                          );
                          return;
                        }

                        final now = DateTime.now();

                        final reminderTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );

                        final reminder = Reminder(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          time: reminderTime,
                          title: titleController.text,
                          isActive: true,
                        );

                        viewModel.add(reminder);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save Reminder"),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// FORMAT TIME
  String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReminderViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 15),
                  Text(
                    "No reminders yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap + to add your first reminder",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.reminders.length,
            itemBuilder: (context, index) {
              final r = viewModel.reminders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: r.isActive
                        ? [Color(0xFFE3F2FD), Color(0xFFBBDEFB)]
                        : [Colors.grey.shade200, Colors.grey.shade300],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// TIME
                    Text(
                      formatTime(r.time),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// TITLE
                    Expanded(
                      child: Text(
                        r.title,
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),

                    /// TOGGLE
                    Switch(
                      value: r.isActive,
                      onChanged: (value) {
                        viewModel.toggleReminder(r, value);
                      },
                    ),

                    /// DELETE
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => viewModel.delete(r.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Reminder"),
        onPressed: () => _showAddReminderSheet(context),

        icon: const Icon(Icons.add),
      ),
    );
  }
}
