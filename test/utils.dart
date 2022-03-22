import 'dart:convert';

import 'package:test/test.dart';

/// Tests that an object created by a [ctor] properly converts with [toJson] and back
/// again using [fromJson], and [expect]ing the original [equals] the deserialized.
/// Additional [expect]ations can be provided through [expects].
void testJson<T>({
  required T Function() ctor,
  required Map<String, dynamic> Function(T model) toJson,
  required T Function(Map<String, dynamic> json) fromJson,
  void Function(T ctor, T json)? expects,
}) {
  final instanceM = ctor();
  final jsonData = jsonDecode(jsonEncode(
    toJson(instanceM),
  )) as Map<String, dynamic>;
  final instanceA = fromJson(jsonData);
  expect(instanceA, equals(instanceM));
  if (expects != null) expects(instanceM, instanceA);
}
