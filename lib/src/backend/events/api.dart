import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../contracts/all.dart';

part 'api.g.dart';

const _envVarPrefix = 'X-Env-';

@JsonSerializable()
class ApiGatewayEvent extends AppContract {
  ApiGatewayEvent({
    required this.version,
    required this.routeKey,
    required this.rawPath,
    required this.rawQueryString,
    required this.cookies,
    required this.headers,
    required this.queryStringParameters,
    required this.requestContext,
    required this.body,
    required this.pathParameters,
    required this.isBase64Encoded,
    required this.stageVariables,
  }) {
    environment = _loadEnvironment(headers);
  }

  final String version;
  final String routeKey;
  final String rawPath;
  final String rawQueryString;
  final List<String> cookies;
  final Map<String, String> headers;
  final Map<String, String> queryStringParameters;
  final ApiGatewayRequestContext requestContext;
  final String body;
  final Map<String, String> pathParameters;
  final bool isBase64Encoded;
  final Map<String, String> stageVariables;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late final UnmodifiableMapView<String, String> environment;

  bool hasHeader(String key) {
    return headers.containsKey(key);
  }

  String? getHeader(String key, [String? fallback]) {
    return headers[key] ?? fallback;
  }

  bool hasEnv(String key) {
    final envKey = '$_envVarPrefix$key';
    return environment.containsKey(envKey);
  }

  String? getEnv(String key, [String? fallback]) {
    final envKey = '$_envVarPrefix$key';
    return hasEnv(key) ? environment[envKey] : fallback;
  }

  bool? getEnvBool(String key, [bool? fallback]) {
    return hasEnv(key) && getEnv(key) != null
        ? getEnv(key)?.toLowerCase() == 'true'
        : fallback;
  }

  num? getEnvNum(String key, [num? fallback]) {
    return hasEnv(key) && getEnv(key) != null
        ? num.parse(getEnv(key)!)
        : fallback;
  }

  static UnmodifiableMapView<String, String> _loadEnvironment(
    Map<String, String> headers,
  ) {
    if (headers.isEmpty) {
      return UnmodifiableMapView<String, String>(<String, String>{});
    }
    return UnmodifiableMapView<String, String>(
      Map<String, String>.fromEntries(
        headers.keys
            .where((k) => k.startsWith('X-Env-'))
            .map((k) => MapEntry(k, headers[k]!)),
      ),
    );
  }

  factory ApiGatewayEvent.fromJson(Map<String, dynamic> json) =>
      _$ApiGatewayEventFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApiGatewayEventToJson(this);
}

@JsonSerializable()
class ApiGatewayRequestContext extends AppContract {
  ApiGatewayRequestContext({
    required this.accountId,
    required this.apiId,
    required this.authorizer,
    required this.domainName,
    required this.domainPrefix,
    required this.http,
    required this.requestId,
    required this.routeKey,
    required this.stage,
    required this.time,
    required this.timeEpoch,
  });

  final String accountId;
  final String apiId;
  final Map<String, ApiGatewayAuthorizer> authorizer;
  final String domainName;
  final String domainPrefix;
  final Map<String, String> http;
  final String requestId;
  final String routeKey;
  final String stage;
  final DateTime time;
  final int timeEpoch;

  factory ApiGatewayRequestContext.fromJson(Map<String, dynamic> json) =>
      _$ApiGatewayRequestContextFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApiGatewayRequestContextToJson(this);
}

@JsonSerializable()
class ApiGatewayAuthorizer extends AppContract {
  ApiGatewayAuthorizer({required this.claims, required this.scopes});

  final Map<String, String> claims;
  final List<String> scopes;

  factory ApiGatewayAuthorizer.fromJson(Map<String, dynamic> json) =>
      _$ApiGatewayAuthorizerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApiGatewayAuthorizerToJson(this);
}
