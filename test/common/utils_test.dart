import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:endaft_core/client.dart';
import 'package:collection/collection.dart';
import 'package:endaft_core/client_test.dart';

void main() {
  group('Utils Tests', () {
    test('Verifies randomBool Works As Expected', () {
      final randomSet = List<bool>.generate(100, (_) => randomBool());

      expect(randomSet.every((v) => v), isFalse);
      expect(randomSet.every((v) => !v), isFalse);
    });

    test('Verifies randomInt Works As Expected', () {
      final factor = 5;
      final randomSet = List<int>.generate(
        100,
        (i) => randomInt(i, math.max(i, 1) * factor),
      );

      expect(
        randomSet
            .whereIndexed((i, v) => v.between(i, math.max(i, 1) * factor))
            .length,
        equals(randomSet.length),
      );
    });

    test('Verifies randomInt Throws When min > max', () {
      expect(() => randomInt(10, 2), throwsA(isA<AssertionError>()));
    });

    test('Verifies makeFakes Works As Expected', () {
      final count = 20;
      final factor = 5;
      final List<FakeThing> things = [];
      expect(
        () {
          things.addAll(
            makeFakes(
              count: count,
              factory: (i, n, b) =>
                  FakeThing(n(i, math.max(i, 1) * factor), b()),
            ),
          );
        },
        returnsNormally,
      );
      expect(things, isNotNull);
      expect(things, isNotEmpty);
      expect(things.length, count);
      expect(things.every((v) => v.yesOrNo), isFalse);
      expect(things.every((v) => !v.yesOrNo), isFalse);
      expect(
        things
            .whereIndexed(
                (i, v) => v.number.between(i, math.max(i, 1) * factor))
            .length,
        equals(things.length),
      );
    });
  });
}

class FakeThing {
  FakeThing(this.number, this.yesOrNo);

  final int number;
  final bool yesOrNo;
}
