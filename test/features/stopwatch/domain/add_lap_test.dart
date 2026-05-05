import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/add_lap.dart';

void main() {
  test('Should add lap correctly' , () {
    final usecase = AddLapUseCase();

    final result = usecase([], 1000);

    expect(result.length, 1);
    expect(result.first.lapIndex, 1);
  });
}