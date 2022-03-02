import 'package:http/http.dart' as http;
import 'package:injector/injector.dart';
import 'package:aws_lambda_dart_runtime/runtime/runtime.dart';

import 'config.dart';
import 'handler.dart';
import '../common/registry.dart' as common;

/// The server-side injection registry.
abstract class BaseServerRegistry<TConfig extends BaseServerConfig>
    extends common.Registry<TConfig> {
  @override
  void setup(TConfig config) {
    // Register default implementations here
    injector
      ..registerSingleton<TConfig>(() => config)
      ..registerSingleton<http.Client>(() => http.Client())
      ..register<Runtime>(Factory.singleton(() => Runtime()))
      ..register<BaseAppApiHandler>(withConfig((c) => BaseAppApiHandler(
            config: c,
            httpClient: httpClient,
          )));
  }

  /// Gets the AWS Lambda [Runtime].
  Runtime get runtime => injector.get<Runtime>();

  /// Gets the [http.Client] for API requests.
  http.Client get httpClient => injector.get<http.Client>();

  /// Gets the [BaseAppApiHandler] for handling requests.
  BaseAppApiHandler get handler => injector.get<BaseAppApiHandler>();
}
