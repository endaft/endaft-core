import 'dart:async';

import 'package:http/http.dart' as http;

import 'config.dart';
import 'api_request.dart';
import '../messages/base.dart';

typedef ApiTimeoutHandler<TResponse> = FutureOr<TResponse?> Function()?;

class BaseAppApi<TConfig extends BaseClientConfig> {
  BaseAppApi({required this.config, required this.httpClient}) {
    timeout = Duration(seconds: config.timeoutSeconds);
  }

  /// The configured request timeout [Duration].
  late final Duration timeout;

  /// The [TConfig] instance from the registry.
  final TConfig config;

  final http.Client httpClient;

  Future<TResponse?> makeRequest<TResponse extends ResponseBase,
      TRequest extends RequestBase>({
    required String url,
    required TRequest request,
    required TConfig config,
    required JsonDeserializer<TResponse> fromJson,
    ApiTimeoutHandler<TResponse> onTimeout,
  }) {
    return ApiRequest<TRequest, TResponse>(
        request: request,
        httpClient: httpClient,
        resolveUrl: config.resolveUrl,
        requestConfig: ApiRequestConfig(
          url: config.resolveUrl(url),
          authToken: _authToken,
          fromJson: fromJson,
        )).getResponse().timeout(timeout, onTimeout: onTimeout);
  }

  // ignore: unused_field
  String _authToken = "";

  Future<void> login() {
    _authToken = "";
    return Future.value();
  }

  Future<void> logout() {
    _authToken = "";
    return Future.value();
  }
}
