import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/add_lap.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/get_elapsed_time.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/lap_analytics.dart';

enum StopwatchStatus { initial, running, paused }

class StopwatchViewModel extends ChangeNotifier {
  final StopwatchRepository repository;

  StopwatchViewModel(this.repository) {
    init();
  }

  String time = "00:00:00";
  StopwatchStatus status = StopwatchStatus.initial;
  List<Lap> laps = [];

  final GetElapsedTimeUseCase _format = GetElapsedTimeUseCase();
  final AddLapUseCase _addLapUseCase = AddLapUseCase();
  final LapAnalyticsUseCase _analyticsUseCase = LapAnalyticsUseCase();

  StreamSubscription? _timeSubscription;

  void init() {
    _timeSubscription = repository.timeStream.listen((duration) {
      time = _format(duration.inMilliseconds);
      notifyListeners();
    });
  }

  void start() {
    repository.start();
    status = StopwatchStatus.running;
    notifyListeners();
  }

  void stop() {
    repository.pause();
    status = StopwatchStatus.paused;
    notifyListeners();
  }

  void reset() {
    repository.reset();
    laps = [];
    status = StopwatchStatus.initial;
    notifyListeners();
  }

  void addLap() {
    laps = _addLapUseCase(laps, repository.currentElapsedMs);
    notifyListeners();
  }

  String format(int ms) => _format(ms);

  Lap? get fastestLap => _analyticsUseCase.fastest(laps);
  Lap? get slowestLap => _analyticsUseCase.slowest(laps);

  @override
  void dispose() {
    _timeSubscription?.cancel();
    super.dispose();
  }
}
