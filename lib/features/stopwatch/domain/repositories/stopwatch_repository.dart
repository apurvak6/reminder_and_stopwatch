abstract class StopwatchRepository {
  Stream<Duration> get timeStream;

  int get currentElapsedMs;

  void start();
  void pause();
  void reset();
}
