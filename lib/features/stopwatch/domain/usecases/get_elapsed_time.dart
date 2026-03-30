class GetElapsedTime {
  String call(int ms) {
    var secs = ms ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    final milliseconds = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds:$milliseconds';
  }
}
