// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiGatewayEvent _$ApiGatewayEventFromJson(Map<String, dynamic> json) =>
    ApiGatewayEvent(
      version: json['version'] as String,
      routeKey: json['routeKey'] as String,
      rawPath: json['rawPath'] as String,
      rawQueryString: json['rawQueryString'] as String,
      cookies:
          (json['cookies'] as List<dynamic>).map((e) => e as String).toList(),
      headers: Map<String, String>.from(json['headers'] as Map),
      queryStringParameters:
          Map<String, String>.from(json['queryStringParameters'] as Map),
      requestContext: ApiGatewayRequestContext.fromJson(
          json['requestContext'] as Map<String, dynamic>),
      body: json['body'] as String,
      pathParameters: Map<String, String>.from(json['pathParameters'] as Map),
      isBase64Encoded: json['isBase64Encoded'] as bool,
      stageVariables: Map<String, String>.from(json['stageVariables'] as Map),
    );

Map<String, dynamic> _$ApiGatewayEventToJson(ApiGatewayEvent instance) =>
    <String, dynamic>{
      'version': instance.version,
      'routeKey': instance.routeKey,
      'rawPath': instance.rawPath,
      'rawQueryString': instance.rawQueryString,
      'cookies': instance.cookies,
      'headers': instance.headers,
      'queryStringParameters': instance.queryStringParameters,
      'requestContext': instance.requestContext,
      'body': instance.body,
      'pathParameters': instance.pathParameters,
      'isBase64Encoded': instance.isBase64Encoded,
      'stageVariables': instance.stageVariables,
    };

ApiGatewayRequestContext _$ApiGatewayRequestContextFromJson(
        Map<String, dynamic> json) =>
    ApiGatewayRequestContext(
      accountId: json['accountId'] as String,
      apiId: json['apiId'] as String,
      authorizer: (json['authorizer'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, ApiGatewayAuthorizer.fromJson(e as Map<String, dynamic>)),
      ),
      domainName: json['domainName'] as String,
      domainPrefix: json['domainPrefix'] as String,
      http: Map<String, String>.from(json['http'] as Map),
      requestId: json['requestId'] as String,
      routeKey: json['routeKey'] as String,
      stage: json['stage'] as String,
      time: DateTime.parse(json['time'] as String),
      timeEpoch: json['timeEpoch'] as int,
    );

Map<String, dynamic> _$ApiGatewayRequestContextToJson(
        ApiGatewayRequestContext instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'apiId': instance.apiId,
      'authorizer': instance.authorizer,
      'domainName': instance.domainName,
      'domainPrefix': instance.domainPrefix,
      'http': instance.http,
      'requestId': instance.requestId,
      'routeKey': instance.routeKey,
      'stage': instance.stage,
      'time': instance.time.toIso8601String(),
      'timeEpoch': instance.timeEpoch,
    };

ApiGatewayAuthorizer _$ApiGatewayAuthorizerFromJson(
        Map<String, dynamic> json) =>
    ApiGatewayAuthorizer(
      claims: Map<String, String>.from(json['claims'] as Map),
      scopes:
          (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ApiGatewayAuthorizerToJson(
        ApiGatewayAuthorizer instance) =>
    <String, dynamic>{
      'claims': instance.claims,
      'scopes': instance.scopes,
    };
