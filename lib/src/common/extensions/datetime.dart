extension DateTimeExtensions on DateTime {
  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is `yyyy-MM-dd`,
  /// where:
  ///
  /// * `yyyy` is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999,
  ///   otherwise it is a signed six digit representation of the year.
  /// * `MM` is the month in the range 01 to 12,
  /// * `dd` is the day of the month in the range 01 to 31
  String toIso8601DateString() => toIso8601String().split("T").first;

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is `HH:mm:ss.mmmuuuZ` for UTC time, and
  /// `HH:mm:ss.mmmuuu` (no trailing "Z") for local/non-UTC time,
  /// where:
  ///
  /// * `HH` are hours in the range 00 to 23,
  /// * `mm` are minutes in the range 00 to 59,
  /// * `ss` are seconds in the range 00 to 59 (no leap seconds),
  /// * `mmm` are milliseconds in the range 000 to 999, and
  /// * `uuu` are microseconds in the range 001 to 999. If [microsecond] equals
  ///   0, then this part is omitted.
  String toIso8601TimeString() => toIso8601String().split("T").last;
}
