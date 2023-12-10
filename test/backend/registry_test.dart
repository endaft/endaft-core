import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:endaft_core/server_test.dart';

void main() {
  group('Backend Registry Tests', () {
    test('Verifies Basics Works As Expected', () {
      final config = MockConfig(const <String, String>{});
      final registry = MockRegistry();

      expect(config, isNotNull);
      expect(registry, isNotNull);
      expect(() => registry.useConfig(config), returnsNormally);

      expect(registry.config, isNotNull);
      expect(registry.config, equals(config));

      expect(registry.runtime, isNotNull);
      expect(registry.runtime, isA<Runtime>());

      expect(registry.httpClient, isNotNull);
      expect(registry.httpClient, isA<http.Client>());

      expect(registry.handler, isNotNull);
      expect(registry.handler, isA<BaseAppApiHandler>());
    });
  });
}

class MockConfig extends BaseServerConfig {
  MockConfig(super.env);
}

class MockRegistry extends BaseServerRegistry<MockConfig> {}
