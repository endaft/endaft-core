import '../common/config.dart';

/// The configuration for the client API.
abstract class BaseClientConfig extends BaseConfig implements CognitoConfig {
  /// Creates a new instance of [BaseClientConfig] with the specified [env] map.
  BaseClientConfig([super.env]);

  /// The base URL for API endpoints.
  String get baseUrl;

  /// The request timeout in seconds.
  int get timeoutSeconds;

  /// Resolves a [relative] URL to an absolute using the [baseUrl].
  Uri resolveUrl(String relative);
}

/// The required Cognito configuration
abstract class CognitoConfig {
  /// Indicates if cognito is enabled or not.
  bool get cognitoEnabled;

  /// The Cognito user pool identifier.
  String get cognitoUserPoolId;

  /// The client identifier issued by Cognito.
  String get cognitoClientId;

  /// The client secret issued by Cognito.
  String? get cognitoClientSecret;

  /// The endpoint used to communication with Cognito. Typically endaft uses
  /// `https://id.your_domain.tld`.
  String? get cognitoEndpoint;
}
