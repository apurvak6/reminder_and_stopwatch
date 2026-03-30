class GetFormattedTime {
  String call(Duration d) {
    final h = d.inHours;
    final minutes =d.inMinutes ~/ 60;
    final seconds = d.inSeconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }
}
