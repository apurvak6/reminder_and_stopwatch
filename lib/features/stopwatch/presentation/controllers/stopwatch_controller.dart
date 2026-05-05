import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/add_lap.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/get_elapsed_time.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/lap_analytics.dart';

enum StopwatchStatus { initial, running, paused }

class StopwatchController extends GetxController {
  final StopwatchRepository repository;

  StopwatchController(this.repository);

  final time = "00:00:00".obs;
  final status = StopwatchStatus.initial.obs;
  final laps = <Lap>[].obs;

  final GetElapsedTimeUseCase _format = GetElapsedTimeUseCase();
  final AddLapUseCase _addLapUseCase = AddLapUseCase();
  final LapAnalyticsUseCase _analyticsUseCase = LapAnalyticsUseCase();

  @override
  void onInit() {
    super.onInit();

    repository.timeStream.listen((duration) {
      time.value = _format(duration.inMilliseconds);
    });
  }

  void start() {
    repository.start();
    status.value = StopwatchStatus.running;
  }

  void stop() {
    repository.pause();
    status.value = StopwatchStatus.paused;
  }

  void reset() {
    repository.reset();
    laps.value = [];
    status.value = StopwatchStatus.initial;
  }

  void addLap() {
    laps.value = _addLapUseCase(laps, repository.currentElapsedMs);
  }

  String format(int ms) => _format(ms);

  Lap? get fastestLap => _analyticsUseCase.fastest(laps);
  Lap? get slowestLap => _analyticsUseCase.slowest(laps);
}
