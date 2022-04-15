/// The injection library
library common.registry;

import 'package:meta/meta.dart';
import 'package:injector/injector.dart';

import 'config.dart';

/// The function signature of a configuration-driven factory builder
typedef ConfigBuilder<T, TConfig extends BaseConfig> = T Function(
  TConfig config,
);

/// An injection registry.
abstract class Registry<TConfig extends BaseConfig> {
  /// Gets the [Injector] behind this instance.
  /// This is useful for injecting mocks for testing
  @nonVirtual
  Injector get injector => Injector.appInstance;

  /// Sets up the registry with access to a [config].
  void setup(TConfig config);

  /// Sets the available [config] for factories requiring configuration.
  @nonVirtual
  void useConfig(TConfig config) {
    if (!_isSetup) {
      _isSetup = true;
      injector.removeByKey<TConfig>();
      setup(config);
    }
  }

  /// Resets the [Registry] state, allowing it to be reconfigured.
  @nonVirtual
  void reset() {
    _isSetup = false;
  }

  bool _isSetup = false;

  /// Gets the [TConfig] used by the registry and its components.
  TConfig get config => injector.get<TConfig>();

  /// Registers a singleton builder for an object that requires configuration values
  @nonVirtual
  Factory<T> withConfig<T>(
    ConfigBuilder<T, TConfig> builder, {
    bool singleton = true,
  }) {
    final config = injector.get<TConfig>();
    return singleton
        ? Factory.singleton(() => builder(config))
        : Factory.provider(() => builder(config));
  }
}
