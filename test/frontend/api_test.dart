import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:endaft_core/client_test.dart';

void main() {
  group('Frontend API Tests', () {
    final cognitoEndpoint = 'https://id.test.my-great.app/';

    setUp(() {
      TestRegistry().useConfig(getTestConfig({
        'AWS_COGNITO_ENDPOINT': cognitoEndpoint,
        'AWS_COGNITO_CLIENT_ID': '1234567890FAKECLIENTID0987654321',
        'AWS_COGNITO_USER_POOL_ID': '1234567890_FAKEUSERPOOLID_0987654321',
        'AWS_COGNITO_CLIENT_SECRET': '1234567890FAKECLIENTSECRET0987654321',
      }));
      registerFallbackValue(<String, dynamic>{});
      registerFallbackValue(Uri.parse('http://testing'));
    });

    test('Verifies makeRequest Works As Expected', () async {
      final api = TestRegistry().appApi;
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.get(
            any(that: uriEndsWith('/fake')),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(TestResponse().toJson()),
            200,
          ));

      await expectLater(api.getFake(), completes);
    });

    test('Login Works As Expected', () async {
      final api = TestRegistry().appApi;
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.post(any(that: uriStartsWith(cognitoEndpoint)),
          body: any(named: 'body'),
          headers: any(
            named: 'headers',
            that: containsPair(
              'X-Amz-Target',
              'AWSCognitoIdentityProviderService.InitiateAuth',
            ),
          ))).thenAnswer((_) async => http.Response(
            jsonEncode(<String, dynamic>{
              'ChallengeParameters': <String, dynamic>{
                'USER_ID_FOR_SRP': '1234567890FAKEIDTOKEN0987654321',
                'SRP_B': BigInt.from(randomInt(9999, 999999)).toRadixString(16),
                'SALT': BigInt.from(randomInt(9999, 999999)).toRadixString(16),
                'SECRET_BLOCK': base64Encode(
                  utf8.encode('1234567890FAKESECRETBLOCK0987654321'),
                ),
              },
            }),
            200,
          ));

      when(() => client.post(any(that: uriStartsWith(cognitoEndpoint)),
          body: any(named: 'body'),
          headers: any(
            named: 'headers',
            that: containsPair(
              'X-Amz-Target',
              'AWSCognitoIdentityProviderService.RespondToAuthChallenge',
            ),
          ))).thenAnswer((_) async => http.Response(
            jsonEncode(<String, dynamic>{
              'AuthenticationResult': <String, dynamic>{
                'IdToken': '0.${base64Encode(
                  utf8.encode('{"sub":"1234567890FAKEIDTOKEN0987654321"}'),
                )}',
                'AccessToken': '0.${base64Encode(
                  utf8.encode('{"sub":"1234567890FAKEACCESSTOKEN0987654321"}'),
                )}',
                'RefreshToken': '1234567890FAKEREFRESHTOKEN0987654321',
              },
            }),
            200,
          ));

      await expectLater(
        api.login('tester@testing.test', '1234567890TESTING0987654321'),
        completes,
      );
    });

    test('Logout Works As Expected', () async {
      final api = TestRegistry().appApi;
      await expectLater(api.logout(), completes);
    });

    test('Gets Hosted Login URL As Expected', () {
      final api = TestRegistry().appApi;
      final config = TestRegistry().config;
      late final String hostedLoginUrl;

      expect(api, isNotNull);
      expect(() => hostedLoginUrl = api.hostedLoginUrl(), returnsNormally);
      expect(hostedLoginUrl, isNotNull);
      expect(hostedLoginUrl, contains('https://${config.cognitoEndpoint}'));
      expect(hostedLoginUrl, contains('client_id=${config.cognitoClientId}'));
    });

    test('Hosted Code Capture Works As Expected', () {
      final api = TestRegistry().appApi;
      final authCode = '1234567890FAKEAUTHCODE0987654321';
      final redirectUrl = 'myapp://?code=$authCode';
      late final String? hostedCode;

      expect(api, isNotNull);
      expect(() {
        hostedCode = api.hostedCodeCapture(redirectUrl);
      }, returnsNormally);
      expect(hostedCode, isNotNull);
      expect(hostedCode, equals(authCode));
    });

    test('Hosted Code Login Works As Expected', () async {
      final api = TestRegistry().appApi;
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.post(
            any(that: uriStartsWith(cognitoEndpoint)),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(<String, dynamic>{
              'id_token': '0.${base64Encode(
                utf8.encode(
                    '{"sub":"1234567890FAKEIDTOKEN0987654321","exp":987654321}'),
              )}',
              'access_token': '0.${base64Encode(
                utf8.encode(
                    '{"sub":"1234567890FAKEACCESSTOKEN0987654321","exp":987654321}'),
              )}',
              'refresh_token': '1234567890FAKEREFRESHTOKEN0987654321',
            }),
            200,
          ));

      when(() => client.post(any(that: uriStartsWith(cognitoEndpoint)),
          body: any(named: 'body'),
          headers: any(
            named: 'headers',
            that: containsPair(
              'X-Amz-Target',
              'AWSCognitoIdentityProviderService.GetUser',
            ),
          ))).thenAnswer((_) async => http.Response(
            jsonEncode(<String, dynamic>{
              'UserAttributes': [
                <String, dynamic>{
                  'Name': 'email',
                  'Value': 'tester@testing.tld',
                }
              ]
            }),
            200,
          ));

      expect(api, isNotNull);
      await expectLater(
        api.hostedCodeLogin('1234567890FAKEAUTHCODE0987654321').then((value) {
          expect(api.user, isNotNull);
        }),
        completes,
      );
      await expectLater(
        api.logout().then((value) {
          expect(api.user, isNull);
        }),
        completes,
      );
    });

    test('Hosted Code Login Throws As Expected', () async {
      final api = TestRegistry().appApi;
      final client = TestRegistry().httpClient as MockHttpClient;

      when(() => client.post(
                any(that: uriStartsWith(cognitoEndpoint)),
                headers: any(named: 'headers'),
              ))
          .thenAnswer(
              (_) async => http.Response('', 400, reasonPhrase: 'Bad Request'));

      expect(api, isNotNull);
      await expectLater(
        api.hostedCodeLogin('1234567890FAKEAUTHCODE0987654321'),
        throwsA(isA<HttpError>()),
      );
    });

    test('API Throws With Cognito Disabled', () async {
      TestRegistry().useConfig(getTestConfig({
        'AWS_COGNITO_ENABLED': 'false',
        'AWS_COGNITO_CLIENT_ID': '1234567890FAKECLIENTID0987654321',
        'AWS_COGNITO_USER_POOL_ID': '1234567890_FAKEUSERPOOLID_0987654321',
        'AWS_COGNITO_CLIENT_SECRET': '1234567890FAKECLIENTSECRET0987654321',
      }));
      final api = TestRegistry().appApi;

      expect(api, isNotNull);
      expect(
        () => api.hostedLoginUrl(),
        throwsA(isA<StateError>()),
      );
      expect(
        () => api.hostedCodeCapture(''),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        api.hostedCodeLogin('1234567890FAKEAUTHCODE0987654321'),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        api.login('', ''),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        api.logout(),
        throwsA(isA<StateError>()),
      );
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
