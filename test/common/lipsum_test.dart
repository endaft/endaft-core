import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('Lipsum Tests', () {
    test('Verifies createWord Works As Expected', () {
      final single = createWord();
      final singleIter = single.split(' ');

      expect(single, isNotNull);
      expect(single, isNotEmpty);
      expect(singleIter.length, equals(1));
    });

    test('Verifies createWord With Count Works As Expected', () {
      final count = 2;
      final words = createWord(count: count);
      final wordsIter = words.split(' ');

      expect(words, isNotNull);
      expect(words, isNotEmpty);
      expect(words, contains(' '));
      expect(wordsIter.length, equals(count));
    });

    test('Verifies createSentence Works As Expected', () {
      final sentence = createSentence();
      expect(sentence, isNotNull);
      expect(sentence, isNotEmpty);
    });

    test('Verifies createSentence With Count Works As Expected', () {
      final sentence = createSentence(numSentences: 2);
      expect(sentence, isNotNull);
      expect(sentence, isNotEmpty);
    });

    test('Verifies createParagraph Works As Expected', () {
      final paragraph = createParagraph();
      expect(paragraph, isNotNull);
      expect(paragraph, isNotEmpty);
    });

    test('Verifies createParagraph With Count Works As Expected', () {
      final paragraph = createParagraph(numParagraphs: 2);
      expect(paragraph, isNotNull);
      expect(paragraph, isNotEmpty);
    });

    test('Verifies createText With Count Works As Expected', () {
      final text = createText();
      expect(text, isNotNull);
      expect(text, isNotEmpty);
    });
  });
}
