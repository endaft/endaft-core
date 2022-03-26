import 'package:json_annotation/json_annotation.dart';

enum HttpMethod {
  @JsonValue('GET')
  get,
  @JsonValue('HEAD')
  head,
  @JsonValue('POST')
  post,
  @JsonValue('PUT')
  put,
  @JsonValue('DELETE')
  delete,
  @JsonValue('PATCH')
  patch
}
