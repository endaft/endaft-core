library endaft.core;

import 'package:matcher/matcher.dart';

enum MatchMode { startsWith, endsWith, contains }

Matcher uriContains(String part) => _UriMatcher(MatchMode.contains, part);
Matcher uriEndsWith(String suffix) => _UriMatcher(MatchMode.endsWith, suffix);
Matcher uriStartsWith(String prefix) =>
    _UriMatcher(MatchMode.startsWith, prefix);

class _UriMatcher extends Matcher {
  _UriMatcher(this._mode, this._expected);

  final MatchMode _mode;
  final String _expected;

  @override
  Description describe(Description description) =>
      description.add('${_mode.name}(').addDescriptionOf(_expected).add(')\n');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item == null || item is! Uri) return false;
    final uriValue = item.toString();
    switch (_mode) {
      case MatchMode.startsWith:
        return uriValue.startsWith(_expected);
      case MatchMode.endsWith:
        return uriValue.endsWith(_expected);
      case MatchMode.contains:
        return uriValue.contains(_expected);
    }
  }
}
