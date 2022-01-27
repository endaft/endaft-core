import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('StackTrace Extensions Tests', () {
    test('Verifies StackTrace.toStringArray() Works As Expected', () {
      final trace = StackTrace.current;
      final traceLines = trace.toString().split('\n');
      final traceStrings = trace.toStringArray().toList();

      for (var i = 0; i < traceStrings.length; i++) {
        expect(traceStrings[i], equals(traceLines[i]));
      }
    });

    test('Verifies Iterable<String>.toStackTrace() Works As Expected', () {
      final trace = StackTrace.current;
      final traceLines = trace.toString().split('\n');
      final newTrace = traceLines.toStackTrace();
      final newTraceLines = newTrace.toStringArray().toList();

      expect(newTrace, isNotNull);
      expect(newTrace, isA<StackTrace>());

      for (var i = 0; i < newTraceLines.length; i++) {
        expect(newTraceLines[i], equals(traceLines[i]));
      }
    });
  });
}
