import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';

class TimerRepositoryImpl implements TimerRepository {
  final _controller = StreamController<Duration>.broadcast();

  Timer? _timer;
  DateTime? _endTime;

  Duration _remaining = Duration.zero;

  final AudioPlayer _player = AudioPlayer();

  @override
  void pause() {
    _timer?.cancel();
  }

  @override
  Duration get remaining => _remaining;

  @override
  void resume() {
    if (_remaining > Duration.zero) {
      _endTime = DateTime.now().add(_remaining);
      _runTimer();
    }
  }

  @override
  void start(Duration duration) {
    if (duration == Duration.zero) return;

    _endTime = DateTime.now().add(duration);
    _remaining = duration;
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();

      if (_endTime != null && now.isBefore(_endTime!)) {
        _remaining = _endTime!.difference(now);
        _controller.add(_remaining);
      } else {
        _onComplete();
      }
    });
  }

  void _onComplete() async {
    _timer?.cancel();
    _remaining = Duration.zero;
    _controller.add(Duration.zero);

    await _player.play(AssetSource('sounds/alarm.mp3'));
  }

  @override
  void stop() {
    _timer?.cancel();
    _remaining = Duration.zero;
    _controller.add(Duration.zero);
  }

  @override
  Stream<Duration> get timeStream => _controller.stream;

  void dispose() {
    _timer?.cancel();
    _player.dispose();
    _controller.close();
  }
}
