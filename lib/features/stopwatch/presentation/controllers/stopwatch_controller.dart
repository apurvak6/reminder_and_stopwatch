import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/add_lap.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/get_elapsed_time.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/lap_analytics.dart';

enum StopwatchStatus { initial, running, paused }

class StopwatchController extends GetxController {
  final Stopwatch _stopwatch;

  StopwatchController({Stopwatch? stopwatch})
    : _stopwatch = stopwatch ?? Stopwatch();

  final GetElapsedTime getElapsedTime = GetElapsedTime();
  final AddLap _addLap = AddLap();
  final LapAnalytics _analytics = LapAnalytics();

  final status = StopwatchStatus.initial.obs;

  late Timer _timer;

  var time = "00:00:00".obs;
  // var isRunning = false.obs;

  var laps = <Lap>[].obs;

  Lap? get fastestLap => _analytics.fastest(laps);
  Lap? get slowestLap => _analytics.slowest(laps);

  bool get hasStarted => _stopwatch.elapsedMilliseconds > 0;

  bool get isRunning => status.value == StopwatchStatus.running;
  bool get isPaused => status.value == StopwatchStatus.paused;
  bool get isInitial => status.value == StopwatchStatus.initial;

  @override
  void onInit() {
    super.onInit();

    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      time.value = getElapsedTime(_stopwatch.elapsedMilliseconds);
    });
  }

  void start() {
    _stopwatch.start();
    status.value = StopwatchStatus.running;
  }

  void stop() {
    _stopwatch.stop();
    status.value = StopwatchStatus.paused;
  }

  void reset() {
    _stopwatch.reset();
    laps.clear();
    time.value = "00:00:00";
    status.value = StopwatchStatus.initial;
  }

  void addLap() {
    laps.value = _addLap(laps, _stopwatch.elapsedMilliseconds);
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }
}
