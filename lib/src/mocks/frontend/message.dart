import 'dart:io' if (dart.library.html) 'dart:html' show HttpStatus;

import 'package:endaft_core/client.dart';

class MockRequest extends RequestBase {}

class MockResponse extends ResponseBase {
  MockResponse(
      {bool error = false,
      List<String> messages = const [],
      int statusCode = HttpStatus.ok,
      this.data})
      : super();

  final String? data;

  factory MockResponse.fromJson(Map<String, dynamic> json) {
    return MockResponse(data: json['data'].toString());
  }
}
