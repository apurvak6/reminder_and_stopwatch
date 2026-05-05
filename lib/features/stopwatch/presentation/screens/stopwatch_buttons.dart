import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/stopwatch_controller.dart';

class ControlledButton extends StatelessWidget {
  final StopwatchController controller;

  const ControlledButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.status.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// LEFT BUTTON
          if (status == StopwatchStatus.initial)
            ElevatedButton(
              onPressed: controller.start,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: Text("Start"),
            )
          else if (status == StopwatchStatus.running)
            ElevatedButton(
              onPressed: controller.addLap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: const Text("Lap"),
            )
          else if (status == StopwatchStatus.paused)
            ElevatedButton(
              onPressed: controller.reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: const Text("Reset"),
            ),
          SizedBox(width: 12),

          if (status == StopwatchStatus.running)
            ElevatedButton(
              onPressed: controller.stop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: Text("Stop"),
            )
          else if (status == StopwatchStatus.paused)
            ElevatedButton(
              onPressed: controller.start,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: StadiumBorder(),
              ),
              child: const Text("Resume"),
            ),
        ],
      );
    });
  }
}
