class FormatTime {
  static String format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;

    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }
}
