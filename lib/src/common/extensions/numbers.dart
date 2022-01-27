/// Extensions used with numeric data types.
extension NumberExtensions on num {
  /// Indicates if this number is inclusively between [lower] and [upper]
  bool between(num lower, num upper) {
    return this >= lower && this <= upper;
  }

  /// Indicates if this number is exclusively between [lower] and [upper]
  bool betweenEx(num lower, num upper) {
    return this > lower && this < upper;
  }
}
