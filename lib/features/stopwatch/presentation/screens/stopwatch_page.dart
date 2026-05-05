import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/viewmodels/stopwatch_viewmodel.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/screens/stopwatch_buttons.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StopwatchViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            //Time display
            Text(
              viewModel.time,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 48,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 30),

            //Buttons
            Expanded(flex: 1, child: ControlledButton(viewModel: viewModel)),

            Divider(),
            //Laps
            Expanded(
              child: viewModel.laps.isEmpty
                  ? Center(child: Text("No Laps yet!"))
                  : ListView.builder(
                      itemCount: viewModel.laps.length,
                      itemBuilder: (context, index) {
                        final lap = viewModel.laps.reversed.toList()[index];

                        final isFastest = lap == viewModel.fastestLap;
                        final isSlowest = lap == viewModel.slowestLap;

                        Color? color;
                        if (isFastest) color = Colors.green;
                        if (isSlowest) color = Colors.red;

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text("Lap ${lap.lapIndex}"),
                            trailing: Text(
                              viewModel.format(lap.milliseconds),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
