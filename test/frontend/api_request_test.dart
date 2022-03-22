import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:endaft_core/client_test.dart';

typedef HtpClientFunc = Future<http.Response> Function(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
});

class TestRegistry extends BaseClientRegistry {
  TestRegistry._privateConstructor();
  static final TestRegistry _instance = TestRegistry._privateConstructor();
  factory TestRegistry() => _instance;
}

void main() {
  group('Frontend API Request Tests', () {
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

    test('HTTP Errors Are Reported As Expected', () async {
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.head(
                any(that: uriEndsWith('/mocked')),
                headers: any(named: 'headers'),
              ))
          .thenAnswer((iv) async => http.Response('Server Error', 500,
              reasonPhrase: 'An Internal Server Error Ocurred'));

      final request = ApiRequest<MockRequest, MockResponse>(
        request: MockRequest(),
        httpClient: client,
        resolveUrl: TestRegistry().config.resolveUrl,
        requestConfig: ApiRequestConfig(
          url: Uri.parse('/mocked'),
          method: HttpMethod.head,
          fromJson: MockResponse.fromJson,
        ),
      );

      await expectLater(request.getResponse(), throwsA(isA<HttpError>()));
    });

    test('HTTP Redirects Are Followed As Expected', () async {
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.head(
            any(that: uriEndsWith('/mocked')),
            headers: any(named: 'headers'),
          )).thenAnswer((iv) async => http.Response(
            'Redirected',
            303,
            reasonPhrase: 'The Resource Has Moved',
            isRedirect: true,
            headers: {'Location': '/mocked-again'},
          ));

      when(() => client.get(
            any(that: uriEndsWith('/mocked-again')),
            headers: any(named: 'headers'),
          )).thenAnswer((iv) async => http.Response(
            'Redirected',
            301,
            reasonPhrase: 'The Resource Has Moved',
            isRedirect: true,
            /* LOCATION HEADER INTENTIONALLY OMITTED */
          ));

      final request = ApiRequest<MockRequest, MockResponse>(
        request: MockRequest(),
        httpClient: client,
        resolveUrl: TestRegistry().config.resolveUrl,
        requestConfig: ApiRequestConfig(
          url: Uri.parse('/mocked'),
          method: HttpMethod.head,
          fromJson: MockResponse.fromJson,
        ),
      );

      await expectLater(request.getResponse(), throwsA(isA<HttpError>()));
    });

    final basicMethods = [HttpMethod.get, HttpMethod.head];
    for (var method in basicMethods) {
      final methodName = method.name.toUpperCase();
      test('HTTP $methodName Requests Works As Expected', () async {
        final client = TestRegistry().httpClient as MockHttpClient;
        final caller = method == HttpMethod.get ? client.get : client.head;

        when(() => caller(
              any(that: uriEndsWith('/mocked')),
              headers: any(named: 'headers'),
            )).thenAnswer((iv) async => http.Response(
              jsonEncode({'data': methodName}),
              200,
            ));

        final request = ApiRequest<MockRequest, MockResponse>(
          request: MockRequest(),
          httpClient: client,
          resolveUrl: TestRegistry().config.resolveUrl,
          requestConfig: ApiRequestConfig(
            url: Uri.parse('/mocked'),
            method: method,
            fromJson: MockResponse.fromJson,
          ),
        );
        final response = await request.getResponse();

        expect(response, isNotNull);
        expect(response!.statusCode, 200);
        expect(response.data, isNotNull);
        expect(response.data, contains(methodName));
      });
    }

    final bodyMethods = [
      HttpMethod.post,
      HttpMethod.put,
      HttpMethod.patch,
      HttpMethod.delete,
    ];
    for (var method in bodyMethods) {
      final methodName = method.name.toUpperCase();
      test('HTTP $methodName Requests Works As Expected', () async {
        final client = TestRegistry().httpClient as MockHttpClient;
        late final HtpClientFunc caller;
        switch (method) {
          case HttpMethod.post:
            caller = client.post;
            break;
          case HttpMethod.put:
            caller = client.put;
            break;
          case HttpMethod.delete:
            caller = client.delete;
            break;
          case HttpMethod.patch:
            caller = client.patch;
            break;
          default:
            throw AssertionError('Cannot use $methodName in this context.');
        }

        when(() => caller(
              any(that: uriEndsWith('/mocked')),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
              encoding: any(named: 'encoding'),
            )).thenAnswer((iv) async => http.Response(
              jsonEncode({'data': methodName}),
              200,
            ));

        final request = ApiRequest<MockRequest, MockResponse>(
          request: MockRequest(),
          httpClient: client,
          resolveUrl: TestRegistry().config.resolveUrl,
          requestConfig: ApiRequestConfig(
            url: Uri.parse('/mocked'),
            method: method,
            fromJson: MockResponse.fromJson,
          ),
        );
        final response = await request.getResponse();

        expect(response, isNotNull);
        expect(response!.statusCode, 200);
        expect(response.data, isNotNull);
        expect(response.data, contains(methodName));
      });
    }
  });
}
