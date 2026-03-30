import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/usecases/get_formatted_time.dart';

class TimerController extends GetxController {
  var totalDuration = Duration.zero.obs;
  var remainingTime = Duration.zero.obs;// in seconds

  var isRunning = false.obs;
  var isPaused = false.obs;

  final GetFormattedTime getFormattedTime = GetFormattedTime();

  // DateTime? endTime;
  var endTime = Rxn<DateTime>();
  Timer? _timer;

  final AudioPlayer _player = AudioPlayer();

  // String get formattedTime => getFormattedTime(remainingTime.value);

  void start(Duration duration) {
    if(duration == Duration.zero) return;

    totalDuration.value = duration;
    remainingTime.value = duration;

    endTime.value = DateTime.now().add(duration);

    isRunning.value = true;
    isPaused.value = false;


    _startTimer();

  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();

      if (endTime != null && now.isBefore(endTime.value!)) {
        remainingTime.value = endTime.value!.difference(now);

        // time.value = getFormattedTime(remainingTime.value);
      } else {
        _timer?.cancel();
        remainingTime.value = Duration.zero;
        isRunning.value = false;
        print("Timer Done");
        _onComplete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    isPaused.value = true;
    isRunning.value = false;
  }

  void resume() {
    if(remainingTime.value > Duration.zero) {
      endTime.value = DateTime.now().add(remainingTime.value);

      isRunning.value = true;
      isPaused.value = false;
      _startTimer();
    }
  }

  void stop() {
    _timer?.cancel();
    totalDuration.value = Duration.zero;
    remainingTime.value = Duration.zero;
    isRunning.value = false;
    isPaused.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    _player.dispose();
  }

  Future<void> _onComplete() async {
    await _player.play(AssetSource('sounds/alarm.mp3'));
  }
}
