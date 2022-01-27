import 'dart:math';

int _random(int min, int max) => (Random().nextInt(max) + min).floor();

extension CollectionExtensions<T> on Iterable<T> {
  /// Returns a random element from the collection. If there are no items,
  /// returns null. If there's only one item, returns that item.
  T? random() {
    if (length == 0) return null;
    if (length == 1) return first;
    int i = _random(0, length);
    return elementAt(i);
  }
}
