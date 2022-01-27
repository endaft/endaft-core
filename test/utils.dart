import 'dart:convert';

import 'package:test/test.dart';
import 'package:endaft_core/client.dart' as client;

/// Tests that an object properly converts to JSON and back again,
/// [expect]ing the original [equals] the deserialized.
void testJson<T extends client.AppContract>({
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
