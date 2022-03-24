/// A simple library of common utility functions
library common.utils;

import 'dart:convert';
import 'dart:math';

/// The shape of a bool producing function.
typedef RandomBool = bool Function();

/// The shape of a number producing function.
typedef RandomNumber = int Function(int min, int max);

/// The shape of a [T] producing function.
typedef ThingGenerator<T> = T Function(
  int index,
  RandomNumber random,
  RandomBool yesOrNo,
);

/// The internal [Random] instance.
final _rnd = Random();

/// The internal [ascii] character codes for id generation.
const _asciiChars = <int>[
  ...[48, 49, 50, 51, 52, 53, 54, 55, 56, 57], // Digits
  ...[
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90
  ], // Alpha Upper
  ...[
    97,
    98,
    99,
    100,
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    120,
    121,
    122
  ], // Alpha Lower
];

/// Generates a random integer between [min] and [max].
int randomInt(int min, int max) {
  assert(min < max, 'The max value must be great than the min value.');
  return (_rnd.nextInt(max - min) + min).floor();
}

/// Generates a random alpha-numeric [ascii] encoded value of
/// the specified [length] (defaults to `12`).
String randomId([int length = 12]) {
  final max = _asciiChars.length - 1;
  return ascii.decode(List.generate(
    length,
    (index) => _asciiChars[randomInt(0, max)],
  ));
}

/// Generates a random [bool] value.
bool randomBool() => (randomInt(0, 11) / 5).floor() == 1;

/// Generates a non-growable [count] sized list of the items returned by [factory].
List<T> makeFakes<T>({required ThingGenerator<T> factory, int count = 20}) {
  return List<T>.generate(
    count,
    (index) => factory(index, randomInt, randomBool),
    growable: false,
  );
}
