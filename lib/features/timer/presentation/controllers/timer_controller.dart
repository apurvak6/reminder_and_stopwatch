import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/usecases/get_formatted_time.dart';

class TimerController extends GetxController {
  final TimerRepository repository;

  TimerController(this.repository);

  var remainingTime = Duration.zero.obs; // in seconds

  var isRunning = false.obs;
  var isPaused = false.obs;

  DateTime? endTime;

  @override
  void onInit() {
    super.onInit();
    repository.timeStream.listen((d) {
      remainingTime.value = d;
    });
  }

  void start(Duration duration) {
    if (duration == Duration.zero) return;

    repository.start(duration);

    endTime = DateTime.now().add(duration);

    isRunning.value = true;
    isPaused.value = false;
  }

  void pause() {
    repository.pause();
    isPaused.value = true;
    isRunning.value = false;
  }

  void resume() {
    repository.resume();
    endTime = DateTime.now().add(remainingTime.value);

    isRunning.value = true;
    isPaused.value = false;
  }

  void stop() {
    repository.stop();
    endTime = null;
    isRunning.value = false;
    isPaused.value = false;
  }
}
