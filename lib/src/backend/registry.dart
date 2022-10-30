import 'package:http/http.dart' as http;
import 'package:injector/injector.dart';

import '../../server.dart';
import '../common/registry.dart' as common;

final _xEnv = RegExp(r'X-Env-', caseSensitive: false);

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

  /// Augments the current environment with `X-Env` prefixed variables from the
  /// [event] headers, and returns a token that can be used to remove them later.
  ///
  /// Adding values from an [event] will transpose all keys to `UPPERCASE`
  /// because AWS might make them `lowercase` and the lookup is case-sensitive.
  /// To avoid case-sensitivity issues and use your exact case, augment through
  /// [BaseConfig.augmentWith] which should be visible through your derivation.
  String addEventEnv(AwsApiGatewayEvent event) {
    final headers = event.headers?.raw ?? <String, dynamic>{};
    return config.augmentWith(Map<String, String>.fromEntries(
      headers.keys.where((k) => k.startsWith(_xEnv)).map((k) => MapEntry(
          k.replaceFirst(_xEnv, '').toUpperCase(),
          headers[k] is String ? headers[k] as String : headers[k].toString())),
    ));
  }

  /// Removes previous applied environment augments based on the [token] and
  /// returns the [Map] of augments that were applied.
  Map<String, String>? removeEventEnv(String token) {
    return config.removeAugment(token);
  }

  /// Gets the AWS Lambda [Runtime].
  Runtime get runtime => injector.get<Runtime>();

  /// Gets the [http.Client] for API requests.
  http.Client get httpClient => injector.get<http.Client>();

  /// Gets the [BaseAppApiHandler] for handling requests.
  BaseAppApiHandler get handler => injector.get<BaseAppApiHandler>();
}
