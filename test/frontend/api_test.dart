import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:endaft_core/client_test.dart';

class TestRegistry extends BaseClientRegistry {
  TestRegistry._privateConstructor();
  static final TestRegistry _instance = TestRegistry._privateConstructor();
  factory TestRegistry() => _instance;
}

void main() {
  group('Frontend API Tests', () {
    setUpAll(() {
      TestRegistry().useConfig(getTestConfig());
      registerFallbackValue(<String, dynamic>{});
      registerFallbackValue(Uri.parse('http://testing'));
    });

    setUp(() {
      TestRegistry().injector.removeByKey<http.Client>();
      TestRegistry()
          .injector
          .registerSingleton<http.Client>(() => MockHttpClient());
    });

    test('Login Works As Expected', () {
      final api = TestRegistry().appApi;
      expect(() => api.login(), returnsNormally);
    });

    test('Logout Works As Expected', () {
      final api = TestRegistry().appApi;
      expect(() => api.logout(), returnsNormally);
    });
  });
}
