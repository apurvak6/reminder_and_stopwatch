import '../entities/lap_entity.dart';

class LapAnalytics {
  Lap? fastest(List<Lap> laps) {
    if (laps.isEmpty) {
      return null;
    }

    return laps.reduce((a, b) => a.milliseconds < b.milliseconds ? a : b);
  }

  Lap? slowest(List<Lap> laps) {
    if (laps.isEmpty) {
      return null;
    }

    return laps.reduce((a, b) => a.milliseconds > b.milliseconds ? a : b);
  }
}
