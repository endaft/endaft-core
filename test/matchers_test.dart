import 'package:test/test.dart';
import 'package:endaft_core/client_test.dart';

void main() {
  group('Matcher Tests', () {
    test('Uri Matcher Works As Expected', () {
      final uri = Uri.parse('http://host:9041/path/to/file.ext');
      final mContains = uriContains('path/to');
      final mEndsWith = uriEndsWith('to/file.ext');
      final mStartsWith = uriStartsWith('http://host');

      expect(mContains.matches(uri, <dynamic, dynamic>{}), isTrue);
      expect(mEndsWith.matches(uri, <dynamic, dynamic>{}), isTrue);
      expect(mStartsWith.matches(uri, <dynamic, dynamic>{}), isTrue);

      final descC =
          mContains.describe(StringDescription('Uri Matcher ')).toString();
      expect(descC, contains('path/to'));

      final descE =
          mEndsWith.describe(StringDescription('Uri Matcher ')).toString();
      expect(descE, contains('to/file.ext'));

      final descS =
          mStartsWith.describe(StringDescription('Uri Matcher ')).toString();
      expect(descS, contains('http://host'));
    });
  });
}
