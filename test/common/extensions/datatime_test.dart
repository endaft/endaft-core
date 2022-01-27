import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('DateTime Extensions Tests', () {
    test('Verifies toIso8601DateString Works As Expected', () {
      final date = DateTime.now();
      final isoStringFull = date.toIso8601String();
      final isoStringDate = date.toIso8601DateString();
      expect(isoStringFull, startsWith(isoStringDate));
    });

    test('Verifies toIso8601TimeString Works As Expected', () {
      final date = DateTime.now();
      final isoStringFull = date.toIso8601String();
      final isoStringTime = date.toIso8601TimeString();
      expect(isoStringFull, endsWith(isoStringTime));
    });
  });
}
