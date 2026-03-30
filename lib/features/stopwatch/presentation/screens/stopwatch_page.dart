import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/controllers/stopwatch_controller.dart';

class StopwatchPage extends StatelessWidget {
  StopwatchPage({super.key});

  final StopwatchController controller = Get.put(StopwatchController());

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        //Time display
        Obx(
          () => Text(
            controller.time.value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ),

        SizedBox(height: 30),

        //Buttons
        Expanded(flex: 1, child: ControlledButton(controller: controller)),

        SizedBox(height: 20),
        Divider(),
        //Laps
        Expanded(
          child: Obx(() {
            if (controller.laps.isEmpty) {
              return Center(child: Text("No Laps yet!"));
            }

            final reversedLaps = controller.laps.reversed.toList();

            return ListView.builder(
              itemCount: reversedLaps.length,
              itemBuilder: (context, index) {
                final lap = reversedLaps[index];

                final isFastest = lap == controller.fastestLap;
                final isSlowest = lap == controller.slowestLap;

                Color? color;
                if (isFastest) color = Colors.green;
                if (isSlowest) color = Colors.red;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("Lap ${lap.lapIndex}"),
                    trailing: Text(
                      controller.getElapsedTime(lap.milliseconds),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
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
