import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../messages/all.dart';
import '../common/extensions/all.dart';

export '../messages/base.dart' show HttpMethod;

typedef JsonDeserializer<TResponse> = TResponse Function(
  Map<String, dynamic> json,
);

typedef UriResolver = Uri Function(String relative);

@immutable
class ApiRequestConfig<TResponse extends ResponseBase> {
  const ApiRequestConfig({
    required this.url,
    required this.fromJson,
    this.body,
    this.encoding,
    this.authCode,
    this.authToken,
    this.params = const <String, dynamic>{},
    this.headers = const <String, String>{},
    this.method = HttpMethod.get,
  });

  final Uri url;
  final Object? body;
  final String? authCode;
  final String? authToken;
  final HttpMethod method;
  final Encoding? encoding;
  final Map<String, dynamic> params;
  final Map<String, String> headers;
  final JsonDeserializer<TResponse> fromJson;

  Map<String, String> get allHeaders {
    final authHeaders = <String, String>{};
    if (authCode != null) {
      authHeaders['Authorization'] = 'Bearer $authCode';
    }
    if (authToken != null) {
      authHeaders['Cookie'] = 'jwt=$authToken';
    }
    return {...headers, ...authHeaders};
  }
}

class ApiRequest<TRequest extends RequestBase, TResponse extends ResponseBase> {
  ApiRequest({
    required this.request,
    required this.httpClient,
    required this.resolveUrl,
    required this.requestConfig,
  });

  final TRequest request;
  final UriResolver resolveUrl;
  final http.Client httpClient;
  final ApiRequestConfig<TResponse> requestConfig;

  Future<http.Response> _fetch({
    String? overrideUrl,
    HttpMethod? overrideMethod,
  }) async {
    final finalMethod = overrideMethod ?? requestConfig.method;
    final finalUrl = resolveUrl((overrideUrl ?? requestConfig.url.toString()))
        .replace(
            queryParameters:
                requestConfig.params.isEmpty ? null : requestConfig.params);

    switch (finalMethod) {
      case HttpMethod.get:
        return httpClient.get(finalUrl, headers: requestConfig.allHeaders);
      case HttpMethod.head:
        return httpClient.head(finalUrl, headers: requestConfig.allHeaders);
      case HttpMethod.post:
        return httpClient.post(finalUrl,
            headers: requestConfig.allHeaders,
            body: requestConfig.body,
            encoding: requestConfig.encoding);
      case HttpMethod.put:
        return httpClient.put(finalUrl,
            headers: requestConfig.allHeaders,
            body: requestConfig.body,
            encoding: requestConfig.encoding);
      case HttpMethod.delete:
        return httpClient.delete(finalUrl,
            headers: requestConfig.allHeaders,
            body: requestConfig.body,
            encoding: requestConfig.encoding);
      case HttpMethod.patch:
        return httpClient.patch(finalUrl,
            headers: requestConfig.allHeaders,
            body: requestConfig.body,
            encoding: requestConfig.encoding);
    }
  }

  String _getReason(http.Response resp) {
    return resp.reasonPhrase != null ? "(${resp.reasonPhrase})" : "";
  }

  String? _getLocation(Map<String, String> headers) {
    return headers['location'] ?? headers['Location'] ?? headers['LOCATION'];
  }

  Future<TResponse?> getResponse() async {
    var resp = await _fetch();
    while (resp.statusCode.between(300, 400)) {
      var newMethod = resp.statusCode == 303 ? HttpMethod.get : null;
      var newUri = _getLocation(resp.headers)?.split(',').first.trim();
      if (newUri == null || newUri.isEmpty) {
        throw HttpError(
          message: "The server indicated a redirect without a location.",
          uri: requestConfig.url,
          statusCode: resp.statusCode,
        );
      }
      resp = await _fetch(
        overrideUrl: newUri,
        overrideMethod: newMethod,
      );
    }
    if (resp.statusCode >= 400) {
      throw HttpError(
        message: "The request returned a ${resp.statusCode} HTTP status code"
            " ${_getReason(resp)}",
        uri: requestConfig.url,
        statusCode: resp.statusCode,
      );
    }
    return requestConfig.fromJson(
      jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>,
    );
  }
}
