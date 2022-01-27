extension FromStackTraceExtensions on StackTrace {
  Iterable<String> toStringArray() => toString().split('\n');
}

extension ToStackTraceExtensions on Iterable<String> {
  StackTrace toStackTrace() => AppStackTrace(join('\n'));
}

class AppStackTrace implements StackTrace {
  final String _stackTrace;
  const AppStackTrace(this._stackTrace);

  @override
  String toString() => _stackTrace;
}
