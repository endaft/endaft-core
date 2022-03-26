/// The extensible configuration library
library common.config;

import 'dart:collection';

import '../messages/all.dart';

/// The base configuration model
abstract class BaseConfig {
  late final UnmodifiableMapView<String, String> _env;

  BaseConfig([Map<String, String>? env]) {
    _env = UnmodifiableMapView<String, String>(env ?? {});
  }

  /// Gets a value by [name] from the underlying config map, or the [fallback]
  /// if the underlying map does not contain the [name].
  String getOr(String name, {required String fallback}) {
    if (!_env.containsKey(name)) {
      return fallback;
    }
    return _env[name]!;
  }

  /// Gets a value by [name] from the underlying config map, or `null`
  /// if the underlying map does not contain the [name].
  String? tryGet(String name) {
    if (!_env.containsKey(name)) {
      return null;
    }
    return _env[name]!;
  }

  /// Gets a value by [name] from the underlying config map, or throws a
  /// [MissingConfigError] if the underlying map does not contain the [name].
  String getOrThrow(String name) {
    if (!_env.containsKey(name)) {
      throw MissingConfigError(name);
    }
    return _env[name]!;
  }
}
