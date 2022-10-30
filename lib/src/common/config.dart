/// The extensible configuration library
library common.config;

import 'package:uuid/uuid.dart';

import '../messages/all.dart';

/// The base configuration model
abstract class BaseConfig {
  late final Map<String, String> _env;
  final Map<String, Map<String, String>> _augments = {};

  BaseConfig([Map<String, String>? env]) {
    _env = Map<String, String>.from(env ?? <String, String>{});
  }

  /// Adds a set of values to the environment and returns the token for
  /// removing the augments. Augments can be removed calling [removeAugment]
  /// with the returned token.
  String augmentWith(Map<String, String> env) {
    final uuid = Uuid().v4();
    _augments[uuid] = env;
    return uuid;
  }

  /// Returns the removed environment variable set associated to the [token].
  Map<String, String>? removeAugment(String token) {
    return _augments.remove(token);
  }

  /// Gets a value by [name] from the underlying config map, or the [fallback]
  /// if the underlying map does not contain the [name].
  String getOr(String name, {required String fallback}) {
    if (!_env.containsKey(name) &&
        !_augments.values.any((m) => m.containsKey(name))) {
      return fallback;
    }
    return _env[name] ??
        _augments.values.firstWhere((m) => m.containsKey(name))[name]!;
  }

  /// Gets a value by [name] from the underlying config map, or `null`
  /// if the underlying map does not contain the [name].
  String? tryGet(String name) {
    if (!_env.containsKey(name) &&
        !_augments.values.any((m) => m.containsKey(name))) {
      return null;
    }
    return _env[name] ??
        _augments.values.firstWhere((m) => m.containsKey(name))[name];
  }

  /// Gets a value by [name] from the underlying config map, or throws a
  /// [MissingConfigError] if the underlying map does not contain the [name].
  String getOrThrow(String name) {
    if (!_env.containsKey(name) &&
        !_augments.values.any((m) => m.containsKey(name))) {
      throw MissingConfigError(name);
    }
    return _env[name] ??
        _augments.values.firstWhere((m) => m.containsKey(name))[name]!;
  }
}
