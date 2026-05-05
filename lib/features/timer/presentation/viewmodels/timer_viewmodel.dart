import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository repository;

  TimerViewModel(this.repository) {
    init();
  }

  Duration remainingTime = Duration.zero; // in seconds

  bool isRunning = false;
  bool isPaused = false;

  DateTime? endTime;

  StreamSubscription? _timeSubscription;

  void init() {
    _timeSubscription = repository.timeStream.listen((d) {
      remainingTime = d;
      notifyListeners();
    });
  }

  void start(Duration duration) {
    if (duration == Duration.zero) return;

    repository.start(duration);

    endTime = DateTime.now().add(duration);

    isRunning = true;
    isPaused = false;
    notifyListeners();
  }

  void pause() {
    repository.pause();
    isPaused = true;
    isRunning = false;
    notifyListeners();
  }

  void resume() {
    repository.resume();
    endTime = DateTime.now().add(remainingTime);

    isRunning = true;
    isPaused = false;
    notifyListeners();
  }

  void stop() {
    repository.stop();
    endTime = null;
    isRunning = false;
    isPaused = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    super.dispose();
  }
}
