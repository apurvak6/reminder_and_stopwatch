import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/viewmodels/timer_viewmodel.dart';

class MockTimerRepository extends Mock implements TimerRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  late MockTimerRepository repo;
  late TimerViewModel viewModel;

  setUp(() {
    repo = MockTimerRepository();
    when(() => repo.timeStream).thenAnswer((_) => Stream.value(Duration.zero));
    viewModel = TimerViewModel(repo);
  });

  test('should call repository start timer', () {
    //when
    when(() => repo.start(any())).thenAnswer((_) {});

    //act
    viewModel.start(Duration(seconds: 5));

    //assert
    expect(viewModel.isRunning, true);
    verify(() => repo.start(Duration(seconds: 5)));
  });
}

