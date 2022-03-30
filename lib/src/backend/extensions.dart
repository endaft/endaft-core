import 'package:endaft_core/server.dart';

typedef RequestFactory<T extends RequestBase> = T Function(
  AwsApiGatewayEvent event,
);

extension BaseResponseFactories on ResponseBase {
  AwsApiGatewayResponse asApiResponse({
    bool isBase64Encoded = false,
    Map<String, String>? headers,
    int? statusCode,
  }) {
    return AwsApiGatewayResponse.fromJson(toJson(),
        isBase64Encoded: isBase64Encoded,
        statusCode: statusCode ?? this.statusCode,
        headers: headers);
  }

  CloudFrontOriginResponse asOriginResponse({
    String? body,
    bool isBase64Encoded = false,
    Map<String, String>? headers,
    int? statusCode,
  }) {
    return CloudFrontOriginResponse(
      body: body,
      bodyEncoding: isBase64Encoded
          ? CloudFrontBodyEncoding.base64
          : CloudFrontBodyEncoding.text,
      status: statusCode ?? this.statusCode,
      statusDescription: getHttpReason(statusCode ?? this.statusCode),
      headers: CloudFrontHeaders(
          headers: headers?.map(
                (key, value) => MapEntry(key, [
                  {key: value}
                ]),
              ) ??
              {}),
    );
  }
}

extension BaseParsingExtensions on Map<String, dynamic>? {
  int parseIntOr(String key, [int value = -1]) {
    final map = this;
    if (map == null) return value;
    if (!map.containsKey(key)) return value;
    return int.tryParse(map[key].toString()) ?? value;
  }
}
