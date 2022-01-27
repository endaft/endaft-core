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
  void useConfig(TConfig config) {
    injector.removeByKey<TConfig>();
    setup(config);
  }

  /// Registers a singleton builder for an object
  /// that requires configuration values
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
