import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:reminder_and_stopwatch/core/utils/format_time.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/controllers/timer_controller.dart';

import '../controllers/timer_buttons.dart';

class TimerPage extends StatelessWidget {
  final controller = Get.find<TimerController>();

  final hController = TextEditingController();
  final mController = TextEditingController();
  final sController = TextEditingController();

  TimerPage({super.key});

  Duration getInputDuration() {
    final h = int.tryParse(hController.text) ?? 0;
    final m = int.tryParse(mController.text) ?? 0;
    final s = int.tryParse(sController.text) ?? 0;

    return Duration(hours: h, minutes: m, seconds: s);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),

        /// Input
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputBox(hController, "HH"),
            const SizedBox(width: 10),
            _inputBox(mController, "MM"),
            const SizedBox(width: 10),
            _inputBox(sController, "SS"),
          ],
        ),

        SizedBox(height: 30),

        /// Timer display
        Obx(
          () => Text(
            FormatTime.format(controller.remainingTime.value),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 10),

        /// END TIME
        Obx(() {
          if (controller.endTime == null) return const SizedBox();

          final end = controller.endTime!;
          return Text(
            "Ends at: ${end.hour.toString().padLeft(2, '0')}:"
            "${end.minute.toString().padLeft(2, '0')}",
          );
        }),
        SizedBox(height: 30),
        ControlledButtons(controller: controller, getInput: getInputDuration),
      ],
    );
  }

  Widget _inputBox(TextEditingController c, String hint) {
    return SizedBox(
      width: 70,
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
