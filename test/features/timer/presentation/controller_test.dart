import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/lap_analytics.dart';

void main() {
  test('should return fastest lap', () {
    final usecase = LapAnalyticsUseCase();

    final laps = [
      Lap(lapIndex: 1, milliseconds: 3000),
      Lap(lapIndex: 2, milliseconds: 1000),
    ];

    final result = usecase.fastest(laps);

    expect(result!.milliseconds, 1000);

  });
}