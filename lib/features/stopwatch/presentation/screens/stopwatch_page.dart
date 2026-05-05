import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/controllers/stopwatch_controller.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/screens/stopwatch_buttons.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StopwatchController>();

    return Column(
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
                      controller.format(lap.milliseconds),
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
