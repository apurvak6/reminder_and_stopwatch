import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/controllers/stopwatch_controller.dart';

class StopwatchPage extends StatelessWidget {
  StopwatchPage({super.key});

  StopwatchController controller = Get.put(StopwatchController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Time display
          Obx(
            () => Text(
              controller.time.value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 42),
            ),
          ),
          SizedBox(height: 10),
          ControlledButton(controller: controller),

          SizedBox(height: 10),

          Expanded(
            flex: 3,
            child: Obx(() {
              if (controller.laps.isEmpty) {
                return Center(child: Text("No Laps yet"));
              }
              return ListView.builder(
                itemCount: controller.laps.length,
                itemBuilder: (context, index) {
                  final lap = controller.laps[index];

                  final isFastest = lap == controller.fastestLap;
                  final isSlowest = lap == controller.slowestLap;

                  Color? color;
                  if (isFastest) color = Colors.green;
                  if (isSlowest) color = Colors.red;

                  return ListTile(
                    title: Text("Lap ${lap.lapIndex}"),
                    trailing: Text(
                      controller.getElapsedTime(lap.milliseconds),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

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
            ElevatedButton(onPressed: controller.start, child: Text("Start"))
          else if (status == StopwatchStatus.running)
            ElevatedButton(
              onPressed: controller.addLap,
              child: const Text("Lap"),
            )
          else if (status == StopwatchStatus.paused)
            ElevatedButton(
              onPressed: controller.reset,
              child: const Text("Reset"),
            ),
          SizedBox(width: 12),

          if (status == StopwatchStatus.running)
            ElevatedButton(onPressed: controller.stop, child: Text("Stop"))
          else if (status == StopwatchStatus.paused)
            ElevatedButton(
              onPressed: controller.start,
              child: const Text("Resume"),
            ),
        ],
      );
    });
  }
}
