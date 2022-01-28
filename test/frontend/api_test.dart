import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:endaft_core/client_test.dart';

void main() {
  group('Frontend API Tests', () {
    setUpAll(() {
      TestRegistry().useConfig(getTestConfig());
      registerFallbackValue(<String, dynamic>{});
      registerFallbackValue(Uri.parse('http://testing'));
    });

    test('Verifies makeRequest Works As Expected', () {
      final api = TestRegistry().appApi;
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.get(
            any(that: uriEndsWith('/fake')),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(TestResponse().toJson()),
            200,
          ));

      expect(() => api.getFake(), returnsNormally);
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

class TestRequest extends RequestBase {
  TestRequest() : super();

  factory TestRequest.fromJson(Map<String, dynamic> json) => TestRequest();

  @override
  Map<String, dynamic> toJson() => const <String, dynamic>{};
}

class TestResponse extends ResponseBase {
  TestResponse({
    bool error = false,
    List<String> messages = const [],
  }) : super(error: error, messages: messages);

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    return TestResponse(
        error: (json['error'] as bool?) ?? false,
        messages: (json['messages'] as List<dynamic>)
            .map((dynamic e) => e.toString())
            .toList());
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'error': error,
      'messages': messages,
    };
  }
}

class TestApi extends BaseAppApi<TestClientConfig> {
  TestApi({required TestClientConfig config, required http.Client httpClient})
      : super(config: config, httpClient: httpClient);

  Future<TestResponse?> getFake({
    ApiTimeoutHandler<TestResponse> onTimeout,
  }) =>
      makeRequest(
        url: '/fake',
        request: TestRequest(),
        config: config,
        fromJson: TestResponse.fromJson,
        onTimeout: onTimeout,
      );
}

class TestRegistry extends BaseClientRegistry<TestClientConfig> {
  TestRegistry._privateConstructor();
  static final TestRegistry _instance = TestRegistry._privateConstructor();
  factory TestRegistry() => _instance;

  @override
  void setup(TestClientConfig config) {
    injector
      ..clearAll()
      ..registerSingleton<TestClientConfig>(() => config)
      ..registerSingleton<http.Client>(() => MockHttpClient())
      ..register<TestApi>(TestRegistry().withConfig((config) => TestApi(
            config: config,
            httpClient: TestRegistry().httpClient,
          )));
  }

  @override
  TestApi get appApi => injector.get<TestApi>();
}
