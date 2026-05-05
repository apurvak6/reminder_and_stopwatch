import '../entities/lap_entity.dart';

class AddLapUseCase {
  List<Lap> call(List<Lap> current, int elapsedMs) {
    final newLap = Lap(milliseconds: elapsedMs, lapIndex: current.length + 1);
    return [newLap, ...current];
  }
}
