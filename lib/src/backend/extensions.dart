import 'dart:io';
import 'dart:convert';
import 'package:aws_lambda_dart_runtime/events/apigateway_event.dart';

import '../messages/all.dart';

typedef RequestFactory<T extends RequestBase> = T Function(
  AwsApiGatewayEvent event,
);

extension BaseRequestFactories on AwsApiGatewayEvent {
  dynamic getPostedBody() {
    if (body == null || body!.isEmpty) {
      throw ArgumentError.notNull("body");
    }
    return jsonDecode(body!);
  }

  T asRequest<T extends RequestBase>(RequestFactory<T> factory) {
    final request = factory(this);
    return request;
  }

  AwsApiGatewayResponse badRequest() {
    return AwsApiGatewayResponse(statusCode: HttpStatus.badRequest);
  }
}

extension BaseResponseFactories on ResponseBase {
  AwsApiGatewayResponse asGatewayResponse({
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
  int parseIntOr(String key, int value) {
    if (this == null) return value;
    if (!this!.containsKey(key)) return value;
    return int.tryParse(toString()) ?? value;
  }
}
