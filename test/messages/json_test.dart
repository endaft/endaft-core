import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

import '../utils.dart';

void main() {
  group('Messages JSON Tests', () {
    test('(De)Serializes JSON As Expected', () {
      testJson(
        ctor: () => RequestBase(),
        fromJson: RequestBase.fromJson,
      );

      testJson(
        ctor: () => ResponseBase(),
        fromJson: ResponseBase.fromJson,
      );

      testJson(
        ctor: () => ErrorResponse(type: 'test', messages: ['testing']),
        fromJson: ErrorResponse.fromJson,
      );
    });
  });
}
