/// The extensible configuration library
library common.config;

import 'dart:collection';

import '../messages/all.dart';

abstract class BaseConfig {
  late final UnmodifiableMapView<String, String> _env;

  BaseConfig([Map<String, String>? env]) {
    _env = UnmodifiableMapView<String, String>(env ?? {});
  }

  String getOrThrow(String name) {
    if (!_env.containsKey(name)) {
      throw MissingConfigError(name);
    }
    return _env[name]!;
  }
}
