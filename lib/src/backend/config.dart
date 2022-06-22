import 'dart:io';

import '../common/config.dart';

/// The base server configuration definition
abstract class BaseServerConfig extends BaseConfig {
  BaseServerConfig([Map<String, String>? env])
      : super(env ?? Platform.environment);

  /// Gets the `ROOT_DOMAIN` from the current context
  String get domainRoot => getOrThrow('ROOT_DOMAIN');
}
