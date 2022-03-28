import 'package:test/test.dart';
import 'package:endaft_core/server_test.dart';

void main() {
  group('Backend Extensions Tests', () {
    test('Verifies BaseParsingExtensions Works As Expected', () {
      final Map<String, dynamic>? nullMap = null;
      final map = <String, dynamic>{
        'empty-value': '',
        'non-number': 'foo',
        'valid-number': '42',
      };
      expect(nullMap.parseIntOr('any-value'), equals(-1));
      expect(map.parseIntOr('missing-value'), equals(-1));
      expect(map.parseIntOr('empty-value'), equals(-1));
      expect(map.parseIntOr('non-number'), equals(-1));
      expect(map.parseIntOr('valid-number'), equals(42));
    });

    test('Verifies BaseResponseFactories Works As Expected', () {
      final appResp = ResponseBase();
      final apiResp = appResp.asApiResponse();
      expect(apiResp, isNotNull);
      expect(apiResp.statusCode, equals(appResp.statusCode));
    });
  });
}
