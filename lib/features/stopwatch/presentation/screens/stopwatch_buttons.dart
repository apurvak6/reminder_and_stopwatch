import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/stopwatch_viewmodel.dart';

class ControlledButton extends StatelessWidget {
  final StopwatchViewModel viewModel;

  const ControlledButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<StopwatchViewModel>(
      builder: (context, vm, child) {
        final status = vm.status;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// LEFT BUTTON
            if (status == StopwatchStatus.initial)
              ElevatedButton(
                onPressed: vm.start,
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
                onPressed: vm.addLap,
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
                onPressed: vm.reset,
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
                onPressed: vm.stop,
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
                onPressed: vm.start,
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
      },
    );
  }
}
