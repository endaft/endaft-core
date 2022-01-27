import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('Collections Extensions Tests', () {
    test('Verifies random Returns Null As Expected', () {
      final items = <int>[];
      final item = items.random();

      expect(item, isNull);
    });

    test('Verifies random Returns The First Item As Expected', () {
      final items = <int>[42];
      final item = items.random();

      expect(item, isIn(items));
      expect(item, equals(items.first));
    });

    test('Verifies random Returns An Item Item As Expected', () {
      final items = <int>[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];
      final item = items.random();

      expect(item, isIn(items));
    });
  });
}
