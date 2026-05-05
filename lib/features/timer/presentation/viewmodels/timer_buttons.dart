import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/viewmodels/timer_viewmodel.dart';

class ControlledButtons extends StatelessWidget {
  final TimerViewModel viewModel;
  final Duration Function() getInput;

  const ControlledButtons({
    super.key,
    required this.viewModel,
    required this.getInput,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerViewModel>(
      builder: (context, vm, child) {
        if (!vm.isRunning && !vm.isPaused) {
          return ElevatedButton(
            onPressed: () => vm.start(getInput()),
            child: Text("Start"),
          );
        }

        if (vm.isRunning) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: vm.pause,
                child: const Text("Pause"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: vm.stop,
                child: const Text("Stop"),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: vm.resume,
              child: const Text("Resume"),
            ),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: vm.stop, child: const Text("Stop")),
          ],
        );
      },
    );
  }
}
