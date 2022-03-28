import 'package:aws_lambda_dart_runtime/events/apigateway_event.dart';

import '../messages/all.dart';

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
}

extension BaseParsingExtensions on Map<String, dynamic>? {
  int parseIntOr(String key, [int value = -1]) {
    final map = this;
    if (map == null) return value;
    if (!map.containsKey(key)) return value;
    return int.tryParse(map[key].toString()) ?? value;
  }
}
