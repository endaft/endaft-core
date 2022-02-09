library endaft.core.client_test;

import 'dart:collection';

import 'src/frontend/all.dart';
export 'src/frontend/all.dart';

export 'matchers.dart';
export 'src/mocks/frontend/http_client.dart';

Map<String, String> getTestEnv([Map<String, String>? overrides]) {
  return UnmodifiableMapView(Map<String, String>.from(<String, String>{})
    ..addAll({
      'API_BASE_URL': 'http://testing',
      'API_TIMEOUT_SECONDS': '30',
    })
    ..addAll(overrides ?? {}));
}

class TestClientConfig extends BaseClientConfig {
  TestClientConfig([Map<String, String>? env])
      : super(env ?? <String, String>{});

  /// Gets the [BaseClientConfig.baseUrl] from `API_BASE_URL` in the provided env.
  @override
  String get baseUrl => getOrThrow('API_BASE_URL');

  /// Gets the [BaseClientConfig.timeoutSeconds] from `API_TIMEOUT_SECONDS` in the provided env.
  @override
  int get timeoutSeconds => int.parse(getOrThrow('API_TIMEOUT_SECONDS'));

  @override
  Uri resolveUrl(String relative) => Uri.parse(baseUrl).resolve(relative);

  @override
  String get cognitoClientId => getOrThrow('AWS_COGNITO_CLIENT_ID');

  @override
  String? get cognitoClientSecret => getOrThrow('AWS_COGNITO_CLIENT_SECRET');

  @override
  String? get cognitoEndpoint => getOrThrow('AWS_COGNITO_ENDPOINT');

  @override
  String get cognitoUserPoolId => getOrThrow('AWS_COGNITO_USER_POOL_ID');

  @override
  bool get cognitoEnabled =>
      getOr('AWS_COGNITO_ENABLED', fallback: 'true') == 'true';
}

TestClientConfig getTestConfig([Map<String, String>? overrides]) {
  return TestClientConfig(getTestEnv(overrides));
}
