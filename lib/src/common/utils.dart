/// A simple library of common utility functions
library common.utils;

import 'dart:math';

typedef RandomBool = bool Function();
typedef RandomNumber = int Function(int min, int max);
typedef ThingGenerator<T> = T Function(
  int index,
  RandomNumber random,
  RandomBool yesOrNo,
);

final _rnd = Random();
int randomInt(int min, int max) => (_rnd.nextInt(max) + min).floor();

bool randomBool() => (randomInt(0, 11) / 5).floor() == 1;

List<T> makeFakes<T>({required ThingGenerator<T> factory, int count = 20}) {
  return List<T>.generate(
    count,
    (index) => factory(index, randomInt, randomBool),
  );
}
