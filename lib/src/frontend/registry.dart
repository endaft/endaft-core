import 'package:http/http.dart' as http;

import 'api.dart';
import 'config.dart';
import '../common/registry.dart' as common;

/// The server-side injection registry.
abstract class BaseClientRegistry<TConfig extends BaseClientConfig>
    extends common.Registry<TConfig> {
  @override
  void setup(TConfig config) {
    // Register default implementations here
    injector
      ..registerSingleton<TConfig>(() => config)
      ..registerSingleton<http.Client>(() => http.Client())
      ..register<BaseAppApi>(withConfig((c) => BaseAppApi(
            config: c,
            httpClient: httpClient,
          )));
  }

  /// Gets the [http.Client] for API requests.
  http.Client get httpClient => injector.get<http.Client>();

  /// Gets the [BaseAppApi] for handling requests.
  BaseAppApi get appApi => injector.get<BaseAppApi>();
}
