import 'package:test/test.dart';
import 'package:endaft_core/client.dart';
import 'package:endaft_core/client_test.dart';

class MockConfig extends BaseConfig {
  MockConfig(super.env);
}

void main() {
  group('Config Tests', () {
    test('Verifies getOrThrow Without Values Works As Expected', () {
      final config = MockConfig({});

      expect(
        () => config.getOrThrow('foo'),
        throwsA(isA<MissingConfigError>()),
      );
    });

    test('Verifies getOrThrow With Values Works As Expected', () {
      final config = MockConfig({'foo': 'bar'});

      expect(
        config.getOrThrow('foo'),
        equals('bar'),
      );
    });
  });
}
