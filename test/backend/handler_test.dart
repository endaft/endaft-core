import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:endaft_core/server_test.dart';

void main() {
  group('Api Handler Tests', () {
    setUp(() {
      TestRegistry().useConfig(getTestConfig(const {}));
      TestRegistry().injector.removeByKey<Runtime>();
      TestRegistry().injector.registerSingleton<Runtime>(() => MockRuntime());
      registerFallbackValue(Uri.parse('http://testing'));
      registerFallbackValue(http.Request('GET', Uri.parse('http://testing')));
    });

    void testHandlerMain() async {
      Event.registerEvent<ApiGatewayEvent>(ApiGatewayEvent.fromJson);
      TestRegistry().runtime
        ..registerHandler<ApiGatewayEvent>('bootstrap', (context, event) async {
          final errorMessage = event.getHeader('X-Error');
          try {
            if (errorMessage?.isEmpty ?? true) {
              return AwsApiGatewayResponse.fromJson(event.toJson());
            }
            throw AppError(errorMessage!);
          } on AppError catch (e) {
            return e.toResponse().asGatewayResponse();
          }
        })
        ..invoke();
    }

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
              {'X-Env-BUCKET_NAME': bucketName}
            ],
            'X-Env-BUCKET_REGION': [
              {'X-Env-BUCKET_REGION': 'us-east-1'}
            ],
          },
        ),
      );

      await expectLater(
        () => handler.serveSpaFrom(event: event),
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
              {'X-Env-BUCKET_NAME': bucketName}
            ],
            'X-Env-BUCKET_REGION': [
              {'X-Env-BUCKET_REGION': 'us-east-1'}
            ],
          },
        ),
      );

      await expectLater(
        () => handler.serveSpaFrom(event: event),
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

    test('Handles Lambda Request Errors As Expected', () async {
      final resp = MockRuntime().queue(
          getFakeContext(useIacFile: false),
          makeEventData(
            headers: <String, dynamic>{
              'X-Error': 'Some undesirable thing happened.'
            },
          ));

      // Invoke the whole lambda
      expect(testHandlerMain, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(500));
      expect(response.body, isNotNull);
      expect(response.body, isA<String>());

      final error = ErrorResponse.fromJson(
        jsonDecode(response.body!) as Map<String, dynamic>,
      );
      expect(error, isNotNull);
      expect(error, isA<ErrorResponse>());
    });

    test('Handles Lambda Requests As Expected', () async {
      final resp = MockRuntime().queue(getFakeContext(), makeEventData());

      // Invoke the whole lambda
      expect(testHandlerMain, returnsNormally);

      // Wait until we get the response
      final response = await resp;
      expect(response, isNotNull);
      expect(response, isA<AwsApiGatewayResponse>());
      expect(response.statusCode, equals(200));
    });

    test('Handles Empty Mock Queue As Expected', () async {
      // Invoke the whole lambda
      expect(testHandlerMain, returnsNormally);
    });

    test('Handles Lack Of Handler As Expected', () async {
      final resp = MockRuntime().queue(
        getFakeContext(useIacFile: false, handler: 'foobar'),
        makeEventData(),
      );

      // Invoke the whole lambda
      expect(testHandlerMain, returnsNormally);

      await expectLater(resp, throwsA(isA<RuntimeException>()));
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
