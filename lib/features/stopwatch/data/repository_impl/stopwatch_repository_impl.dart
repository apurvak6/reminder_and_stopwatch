import 'dart:async';

import 'package:reminder_and_stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';

class StopwatchRepositoryImpl implements StopwatchRepository {
  final _controller = StreamController<Duration>.broadcast();

  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  Stream<Duration> get timeStream => _controller.stream;

  @override
  int get currentElapsedMs => _stopwatch.elapsedMilliseconds;

  @override
  void pause() {
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
  }

  @override
  void reset() {
    _stopwatch.reset();
    _controller.add(Duration.zero);
    _timer?.cancel();
    _timer = null;
  }

  @override
  void start() {
    if (_timer != null) return;

    _stopwatch.start();
    _timer ??= Timer.periodic(Duration(milliseconds: 30), (_) {
      _controller.add(_stopwatch.elapsed);
    });
  }

  void dispose() {
    _controller.close();
  }
}
