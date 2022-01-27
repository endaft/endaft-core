import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('Numbers Extensions Tests', () {
    test('Verifies between Works As Expected', () {
      final numbers = <num>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

      for (var i = 0; i < numbers.length; i++) {
        final num = numbers[i];
        final low = num - 1;
        final high = num + 1;
        final reason = '$num >= $low && $num <= $high';
        final reasonL = '$low >= $low && $num <= $low';
        final reasonH = '$high >= $low && $high <= $high';

        expect(num.between(low, high), isTrue, reason: reason);
        expect(low.between(low, high), isTrue, reason: reasonL);
        expect(high.between(low, high), isTrue, reason: reasonH);
      }
    });

    test('Verifies betweenEx Works As Expected', () {
      final numbers = <num>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

      for (var i = 0; i < numbers.length; i++) {
        final num = numbers[i];
        final low = num - 1;
        final high = num + 1;
        final reason = '$num > $low && $num < $high';
        final reasonL = '$low > $low && $num < $low';
        final reasonH = '$high > $low && $high < $high';

        expect(num.betweenEx(low, high), isTrue, reason: reason);
        expect(low.betweenEx(low, high), isFalse, reason: reasonL);
        expect(high.betweenEx(low, high), isFalse, reason: reasonH);
      }
    });
  });
}
