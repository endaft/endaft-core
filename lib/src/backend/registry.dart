import 'package:injector/injector.dart';
import 'package:aws_lambda_dart_runtime/runtime/runtime.dart';

import 'config.dart';
import '../common/registry.dart' as common;

/// The server-side injection registry.
abstract class BaseServerRegistry<TConfig extends BaseServerConfig>
    extends common.Registry<TConfig> {
  @override
  void setup(TConfig config) {
    // Register default implementations here
    injector
      ..registerSingleton<TConfig>(() => config)
      ..register<Runtime>(Factory.singleton(() => Runtime()));
  }

  /// Gets the AWS Lambda [Runtime].
  Runtime get runtime => injector.get<Runtime>();
}
