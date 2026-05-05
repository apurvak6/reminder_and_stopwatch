abstract class TimerRepository {
  Stream<Duration> get timeStream;

  Duration get remaining;

  void start(Duration duration);
  void pause();
  void resume();
  void stop();
}
