import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:endaft_core/client_test.dart';

void main() {
  group('Frontend Registry Tests', () {
    test('Verifies Basics Works As Expected', () {
      final config = MockConfig(const <String, String>{});
      final registry = MockRegistry();

      expect(config, isNotNull);
      expect(registry, isNotNull);
      expect(() => registry.useConfig(config), returnsNormally);

      expect(registry.config, isNotNull);
      expect(registry.config, equals(config));

      expect(registry.appApi, isNotNull);
      expect(registry.appApi, isA<BaseAppApi>());

      expect(registry.httpClient, isNotNull);
      expect(registry.httpClient, isA<http.Client>());
    });
  });
}

class MockConfig extends BaseClientConfig {
  MockConfig(Map<String, String>? env) : super(env);

  @override
  String get baseUrl => 'http://testing';

  @override
  Uri resolveUrl(String relative) => Uri.parse(baseUrl).resolve(relative);

  @override
  int get timeoutSeconds => 30;
}

class MockRegistry extends BaseClientRegistry<MockConfig> {}
