import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/controllers/timer_controller.dart';

class ControlledButtons extends StatelessWidget {
  final TimerController controller;
  final Duration Function() getInput;

  const ControlledButtons({
    super.key,
    required this.controller,
    required this.getInput,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isRunning.value && !controller.isPaused.value) {
        return ElevatedButton(
          onPressed: () => controller.start(getInput()),
          child: Text("Start"),
        );
      }

      if (controller.isRunning.value) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: controller.pause,
              child: const Text("Pause"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: controller.stop,
              child: const Text("Stop"),
            ),
          ],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: controller.resume,
            child: const Text("Resume"),
          ),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: controller.stop, child: const Text("Stop")),
        ],
      );
    });
  }
}
