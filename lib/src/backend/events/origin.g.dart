// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudFrontOriginResponse _$CloudFrontOriginResponseFromJson(
        Map<String, dynamic> json) =>
    CloudFrontOriginResponse(
      body: json['body'] as String?,
      bodyEncoding: $enumDecodeNullable(
              _$CloudFrontBodyEncodingEnumMap, json['bodyEncoding']) ??
          CloudFrontBodyEncoding.text,
      headers: json['headers'] == null
          ? null
          : CloudFrontHeaders.fromJson(json['headers'] as Map<String, dynamic>),
      status: json['status'] as int? ?? 200,
      statusDescription: json['statusDescription'] as String? ?? "OK",
    );

Map<String, dynamic> _$CloudFrontOriginResponseToJson(
        CloudFrontOriginResponse instance) =>
    <String, dynamic>{
      'body': instance.body,
      'bodyEncoding': _$CloudFrontBodyEncodingEnumMap[instance.bodyEncoding],
      'headers': instance.headers,
      'status': instance.status,
      'statusDescription': instance.statusDescription,
    };

const _$CloudFrontBodyEncodingEnumMap = {
  CloudFrontBodyEncoding.base64: 'base64',
  CloudFrontBodyEncoding.text: 'text',
};

CloudFrontOriginRequestEvent _$CloudFrontOriginRequestEventFromJson(
        Map<String, dynamic> json) =>
    CloudFrontOriginRequestEvent(
      records: (json['records'] as List<dynamic>)
          .map((e) => CloudFrontRecords.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CloudFrontOriginRequestEventToJson(
        CloudFrontOriginRequestEvent instance) =>
    <String, dynamic>{
      'records': instance.records,
    };

CloudFrontRecords _$CloudFrontRecordsFromJson(Map<String, dynamic> json) =>
    CloudFrontRecords(
      cf: CloudFront.fromJson(json['cf'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudFrontRecordsToJson(CloudFrontRecords instance) =>
    <String, dynamic>{
      'cf': instance.cf,
    };

CloudFront _$CloudFrontFromJson(Map<String, dynamic> json) => CloudFront(
      config: CloudFrontConfig.fromJson(json['config'] as Map<String, dynamic>),
      request:
          CloudFrontRequest.fromJson(json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudFrontToJson(CloudFront instance) =>
    <String, dynamic>{
      'config': instance.config,
      'request': instance.request,
    };

CloudFrontRequest _$CloudFrontRequestFromJson(Map<String, dynamic> json) =>
    CloudFrontRequest(
      clientIp: json['clientIp'] as String,
      headers:
          CloudFrontHeaders.fromJson(json['headers'] as Map<String, dynamic>),
      method: json['method'] as String,
      origin: (json['origin'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, CloudFrontOrigin.fromJson(e as Map<String, dynamic>)),
      ),
      queryString: json['queryString'] as String,
      uri: json['uri'] as String,
      body:
          CloudFrontRequestBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudFrontRequestToJson(CloudFrontRequest instance) =>
    <String, dynamic>{
      'clientIp': instance.clientIp,
      'headers': instance.headers,
      'method': instance.method,
      'origin': instance.origin,
      'queryString': instance.queryString,
      'uri': instance.uri,
      'body': instance.body,
    };

CloudFrontRequestBody _$CloudFrontRequestBodyFromJson(
        Map<String, dynamic> json) =>
    CloudFrontRequestBody(
      inputTruncated: json['inputTruncated'] as bool,
      action: $enumDecode(_$CloudFrontBodyActionEnumMap, json['action']),
      encoding: $enumDecode(_$CloudFrontBodyEncodingEnumMap, json['encoding']),
      data: json['data'] as String?,
    );

Map<String, dynamic> _$CloudFrontRequestBodyToJson(
        CloudFrontRequestBody instance) =>
    <String, dynamic>{
      'inputTruncated': instance.inputTruncated,
      'action': _$CloudFrontBodyActionEnumMap[instance.action],
      'encoding': _$CloudFrontBodyEncodingEnumMap[instance.encoding],
      'data': instance.data,
    };

const _$CloudFrontBodyActionEnumMap = {
  CloudFrontBodyAction.readOnly: 'readOnly',
  CloudFrontBodyAction.replace: 'replace',
};

CloudFrontOrigin _$CloudFrontOriginFromJson(Map<String, dynamic> json) =>
    CloudFrontOrigin(
      customHeaders: CloudFrontHeaders.fromJson(
          json['customHeaders'] as Map<String, dynamic>),
      domainName: json['domainName'] as String,
      keepAliveTimeout: json['keepAliveTimeout'] as int?,
      path: json['path'] as String,
      port: json['port'] as int?,
      protocol: json['protocol'] as String?,
      readTimeout: json['readTimeout'] as int?,
      sslProtocols: (json['sslProtocols'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CloudFrontOriginToJson(CloudFrontOrigin instance) =>
    <String, dynamic>{
      'customHeaders': instance.customHeaders,
      'domainName': instance.domainName,
      'keepAliveTimeout': instance.keepAliveTimeout,
      'path': instance.path,
      'port': instance.port,
      'protocol': instance.protocol,
      'readTimeout': instance.readTimeout,
      'sslProtocols': instance.sslProtocols,
    };

CloudFrontHeaders _$CloudFrontHeadersFromJson(Map<String, dynamic> json) =>
    CloudFrontHeaders(
      headers: (json['headers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => Map<String, String>.from(e as Map))
                .toList()),
      ),
    );

Map<String, dynamic> _$CloudFrontHeadersToJson(CloudFrontHeaders instance) =>
    <String, dynamic>{
      'headers': instance.headers,
    };

CloudFrontConfig _$CloudFrontConfigFromJson(Map<String, dynamic> json) =>
    CloudFrontConfig(
      distributionDomainName: json['distributionDomainName'] as String,
      distributionId: json['distributionId'] as String,
      eventType: json['eventType'] as String,
      requestId: json['requestId'] as String,
    );

Map<String, dynamic> _$CloudFrontConfigToJson(CloudFrontConfig instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'eventType': instance.eventType,
      'distributionId': instance.distributionId,
      'distributionDomainName': instance.distributionDomainName,
    };
