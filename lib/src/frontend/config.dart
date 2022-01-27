import '../common/config.dart';

/// The configuration for the client API.
abstract class BaseClientConfig extends BaseConfig {
  /// Creates a new instance of [BaseClientConfig] with the specified [env] map.
  BaseClientConfig([Map<String, String>? env]) : super(env);

  /// The base URL for API endpoints.
  String get baseUrl;

  /// The request timeout in seconds.
  int get timeoutSeconds;

  /// Resolves a [relative] URL to an absolute using the [baseUrl].
  Uri resolveUrl(String relative);
}
