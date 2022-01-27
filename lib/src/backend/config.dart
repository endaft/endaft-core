import 'dart:io';

import '../common/config.dart';

abstract class BaseServerConfig extends BaseConfig {
  BaseServerConfig([Map<String, String>? env])
      : super(env ?? Platform.environment);
}
