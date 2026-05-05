import 'package:flutter_test/flutter_test.dart';
import 'package:reminder_and_stopwatch/core/utils/format_time.dart';

void main() {
  test('Should format duration correctly' , () {
    final result = FormatTime.format(
      Duration(hours: 1, minutes: 2, seconds: 3)
    );

    expect(result, "01:02:03");
  });
}