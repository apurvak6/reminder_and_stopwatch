import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/entities/lap_entity.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/usecases/lap_analytics.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/controllers/timer_controller.dart';


class MockTimerRepository extends Mock implements TimerRepository{}

void main() {

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  late MockTimerRepository repo;
  late TimerController controller;

  setUp(() {
    repo = MockTimerRepository();
    controller = TimerController(repo);
  });

  test('should call repository start timer', () {
    //when
    when(() => repo.start(any())).thenAnswer((_) {});
    
    //act
    controller.start(Duration(seconds: 5));
    
  //assert
    expect(controller.isRunning.value, true);
    verify(() => repo.start(Duration(seconds: 5)));

  });
}
