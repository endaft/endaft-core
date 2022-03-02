import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:endaft_core/server_test.dart';

void main() {
  group('Api Handler Tests', () {
    setUp(() {
      TestRegistry().useConfig(getTestConfig(const {}));
      registerFallbackValue(Uri.parse('http://testing'));
      registerFallbackValue(http.Request('GET', Uri.parse('http://testing')));
    });

    test('Verifies serveSpaFrom Throws When Missing Key', () async {
      late final TestHandler handler;
      expect(() {
        handler = TestRegistry().handler;
      }, returnsNormally);
      expect(handler, isNotNull);
      expect(handler, isA<BaseAppApiHandler>());

      final String bucketName = 'my-great.app';
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream<List<int>>.value(utf8.encode(
            '<ErrorResponse><Error>'
            '<Code>NoSuchKey</Code>'
            '<Type>NoSuchKey</Type>'
            '<Message>The key does not exist.</Message>'
            '</Error></ErrorResponse>',
          )),
          500,
          headers: <String, String>{},
          request: _.positionalArguments[0] as http.Request,
        ),
      );

      final event = makeOriginEvent(
        requestHost: 'my-great.app',
        requestUri: '/some/client/routed/path',
        originCustomHeaders: CloudFrontHeaders(
          headers: {
            'X-Env-BASE_DOMAIN': [
              {'X-Env-BASE_DOMAIN': 'my-great.app'}
            ],
            'X-Env-BUCKET_NAME': [
              {'X-Env-BASE_DOMAIN': bucketName}
            ],
            'X-Env-BUCKET_REGION': [
              {'X-Env-BASE_DOMAIN': 'us-east-1'}
            ],
          },
        ),
      );

      await expectLater(
        handler.serveSpaFrom(event: event),
        throwsStateError,
      );
    });

    test('Verifies serveSpaFrom Throw When Missing Bucket', () async {
      late final TestHandler handler;
      expect(() {
        handler = TestRegistry().handler;
      }, returnsNormally);
      expect(handler, isNotNull);
      expect(handler, isA<BaseAppApiHandler>());

      final String bucketName = 'my-great.app';
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream<List<int>>.value(utf8.encode(
            '<ErrorResponse><Error>'
            '<Code>NoSuchBucket</Code>'
            '<Type>NoSuchBucket</Type>'
            '<Message>The bucket does not exist.</Message>'
            '</Error></ErrorResponse>',
          )),
          500,
          headers: <String, String>{},
          request: _.positionalArguments[0] as http.Request,
        ),
      );

      final event = makeOriginEvent(
        requestHost: 'my-great.app',
        originCustomHeaders: CloudFrontHeaders(
          headers: {
            'X-Env-BASE_DOMAIN': [
              {'X-Env-BASE_DOMAIN': 'my-great.app'}
            ],
            'X-Env-BUCKET_NAME': [
              {'X-Env-BASE_DOMAIN': bucketName}
            ],
            'X-Env-BUCKET_REGION': [
              {'X-Env-BASE_DOMAIN': 'us-east-1'}
            ],
          },
        ),
      );

      await expectLater(
        handler.serveSpaFrom(event: event),
        throwsStateError,
      );
    });

    test('Verifies serveSpaFrom Works As Expected', () async {
      late final TestHandler handler;
      expect(() {
        handler = TestRegistry().handler;
      }, returnsNormally);
      expect(handler, isNotNull);
      expect(handler, isA<BaseAppApiHandler>());

      final String bucketName = 'my-great.app';
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.send(any())).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream<List<int>>.value(utf8.encode(
            '<html><body>My Great SPA</body></html>',
          )),
          200,
          headers: <String, String>{
            'Content-Disposition': 'inline',
            'Content-Encoding': 'utf-8',
            'Content-Language': 'en-US',
            'Content-Type': 'text/html',
          },
          request: _.positionalArguments[0] as http.Request,
        ),
      );

      final event = makeOriginEvent(
        requestHost: 'my-great.app',
        originCustomHeaders: CloudFrontHeaders(
          headers: {
            'X-Env-BASE_DOMAIN': [
              {'X-Env-BASE_DOMAIN': 'my-great.app'}
            ],
            'X-Env-BUCKET_NAME': [
              {'X-Env-BASE_DOMAIN': bucketName}
            ],
            'X-Env-BUCKET_REGION': [
              {'X-Env-BASE_DOMAIN': 'us-east-1'}
            ],
          },
        ),
      );
      late final CloudFrontOriginResponse response;
      await expectLater(
        handler.serveSpaFrom(event: event).then((value) {
          response = value;
        }),
        completes,
      );
      expect(response, isNotNull);
    });

    test('Verifies serveSpaFrom Throws As Expected', () async {
      TestRegistry().useConfig(getTestConfig(const {}));
      late final TestHandler handler;
      expect(() {
        handler = TestRegistry().handler;
      }, returnsNormally);
      expect(handler, isNotNull);
      expect(handler, isA<BaseAppApiHandler>());

      final event = makeOriginEvent();
      await expectLater(
        () => handler.serveSpaFrom(event: event),
        throwsStateError,
      );
    });
  });
}

class TestHandler extends BaseAppApiHandler<TestServerConfig> {
  TestHandler({
    required TestServerConfig config,
    required http.Client httpClient,
  }) : super(config: config, httpClient: httpClient);
}

class TestRegistry extends BaseServerRegistry<TestServerConfig> {
  TestRegistry._privateConstructor();
  static final TestRegistry _instance = TestRegistry._privateConstructor();
  factory TestRegistry() => _instance;

  @override
  void setup(TestServerConfig config) {
    injector
      ..clearAll()
      ..registerSingleton<TestServerConfig>(() => config)
      ..registerSingleton<http.Client>(() => MockHttpClient())
      ..register<TestHandler>(TestRegistry().withConfig((config) => TestHandler(
            config: config,
            httpClient: httpClient,
          )));
  }

  @override
  TestHandler get handler => injector.get<TestHandler>();
}
