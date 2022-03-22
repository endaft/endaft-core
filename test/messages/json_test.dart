import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

import '../utils.dart';

void main() {
  group('Messages JSON Tests', () {
    test('(De)Serializes JSON As Expected', () {
      testJson<RequestBase>(
        ctor: () => RequestBase(),
        toJson: (model) => model.toJson(),
        fromJson: RequestBase.fromJson,
      );

      testJson<ResponseBase>(
        ctor: () => ResponseBase(),
        toJson: (model) => model.toJson(),
        fromJson: ResponseBase.fromJson,
      );

      testJson<ErrorResponse>(
        ctor: () => ErrorResponse(type: 'test', messages: ['testing']),
        toJson: (model) => model.toJson(),
        fromJson: ErrorResponse.fromJson,
      );
    });
  });
}
