import 'dart:convert';

import 'package:test/test.dart';
import 'package:endaft_core/common.dart';

/// Tests that an object created by a [ctor] properly converts to JSON and back
/// again using [fromJson], and [expect]ing the original [equals] the deserialized.
/// An additional [expect]ations can be provided through [expects].
void testJson<T extends AppContract>({
  required T Function() ctor,
  required T Function(Map<String, dynamic>) fromJson,
  void Function(T ctor, T json)? expects,
}) {
  final instanceM = ctor();
  final jsonData = jsonDecode(jsonEncode(
    instanceM.toJson(),
  )) as Map<String, dynamic>;
  final instanceA = fromJson(jsonData);
  expect(instanceA, equals(instanceM));
  if (expects != null) expects(instanceM, instanceA);
}
