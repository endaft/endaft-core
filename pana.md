
## ✗ Follow Dart file conventions (10 / 20)
### [x] 0/10 points: Provide a valid `pubspec.yaml`

<details>
<summary>
Homepage URL doesn't exist.
</summary>

At the time of the analysis `https://endaft.dev` was unreachable.
</details>

### [*] 5/5 points: Provide a valid `README.md`


### [*] 5/5 points: Provide a valid `CHANGELOG.md`


## ✗ Provide documentation (0 / 10)
### [x] 0/10 points: Package has an example

<details>
<summary>
No example found.
</summary>

See [package layout](https://dart.dev/tools/pub/package-layout#examples) guidelines on how to add an example.
</details>

## ✓ Platform Support (20 / 20)
### [*] 20/20 points: Supports 5 of 6 possible platforms (**iOS**, **Android**, Web, **Windows**, **MacOS**, **Linux**)

* ✓ Android
* ✓ iOS
* ✓ Windows
* ✓ Linux
* ✓ MacOS

These platforms are not supported:

<details>
<summary>
Package not compatible with platform Web
</summary>

Because:
* `package:endaft_core/client.dart` that imports:
* `package:endaft_core/src/frontend/all.dart` that imports:
* `package:endaft_core/src/frontend/registry.dart` that imports:
* `package:endaft_core/src/frontend/api.dart` that imports:
* `package:amazon_cognito_identity_dart_2/cognito.dart` that imports:
* `package:amazon_cognito_identity_dart_2/src/cognito_user.dart` that imports:
* `package:amazon_cognito_identity_dart_2/src/cognito_user_pool.dart` that imports:
* `package:amazon_cognito_identity_dart_2/src/client.dart` that imports:
* `dart:io`
</details>

## ✓ Pass static analysis (30 / 30)
### [*] 30/30 points: code has no errors, warnings, lints, or formatting issues


## ✓ Support up-to-date dependencies (20 / 20)
### [*] 10/10 points: All of the package dependencies are supported in the latest version

|Package|Constraint|Compatible|Latest|
|:-|:-|:-|:-|
|[`amazon_cognito_identity_dart_2`]|`^1.0.5`|1.0.5|1.0.5|
|[`aws_lambda_dart_runtime`]|`^1.1.0`|1.1.0|1.1.0|
|[`aws_s3_api`]|`^1.2.0`|1.2.0|1.2.0|
|[`collection`]|`^1.15.0`|1.15.0|1.15.0|
|[`equatable`]|`^2.0.3`|2.0.3|2.0.3|
|[`http`]|`^0.13.4`|0.13.4|0.13.4|
|[`injector`]|`^2.0.0`|2.0.0|2.0.0|
|[`json_annotation`]|`^4.4.0`|4.4.0|4.4.0|
|[`matcher`]|`^0.12.11`|0.12.11|0.12.11|
|[`meta`]|`^1.7.0`|1.7.0|1.7.0|
|[`mocktail`]|`^0.3.0`|0.3.0|0.3.0|
|[`path`]|`^1.8.0`|1.8.1|1.8.1|

<details><summary>Transitive dependencies</summary>

|Package|Constraint|Compatible|Latest|
|:-|:-|:-|:-|
|[`_fe_analyzer_shared`]|-|36.0.0|36.0.0|
|[`args`]|-|2.3.0|2.3.0|
|[`async`]|-|2.8.2|2.8.2|
|[`boolean_selector`]|-|2.1.0|2.1.0|
|[`charcode`]|-|1.3.1|1.3.1|
|[`clock`]|-|1.1.0|1.1.0|
|[`convert`]|-|3.0.1|3.0.1|
|[`crypto`]|-|3.0.1|3.0.1|
|[`file`]|-|6.1.2|6.1.2|
|[`frontend_server_client`]|-|2.1.2|2.1.2|
|[`glob`]|-|2.0.2|2.0.2|
|[`http_multi_server`]|-|3.2.0|3.2.0|
|[`http_parser`]|-|4.0.0|4.0.0|
|[`intl`]|-|0.17.0|0.17.0|
|[`io`]|-|1.0.3|1.0.3|
|[`js`]|-|0.6.4|0.6.4|
|[`logging`]|-|1.0.2|1.0.2|
|[`mime`]|-|1.0.1|1.0.1|
|[`node_preamble`]|-|2.0.1|2.0.1|
|[`package_config`]|-|2.0.2|2.0.2|
|[`petitparser`]|-|4.4.0|4.4.0|
|[`pool`]|-|1.5.0|1.5.0|
|[`pub_semver`]|-|2.1.0|2.1.0|
|[`shared_aws_api`]|-|1.2.0|1.2.0|
|[`shelf`]|-|1.2.0|1.2.0|
|[`shelf_packages_handler`]|-|3.0.0|3.0.0|
|[`shelf_static`]|-|1.1.0|1.1.0|
|[`shelf_web_socket`]|-|1.0.1|1.0.1|
|[`source_map_stack_trace`]|-|2.1.0|2.1.0|
|[`source_maps`]|-|0.10.10|0.10.10|
|[`source_span`]|-|1.8.2|1.8.2|
|[`stack_trace`]|-|1.10.0|1.10.0|
|[`stream_channel`]|-|2.1.0|2.1.0|
|[`string_scanner`]|-|1.1.0|1.1.0|
|[`term_glyph`]|-|1.2.0|1.2.0|
|[`test_api`]|-|0.4.9|0.4.9|
|[`test_core`]|-|0.4.11|0.4.11|
|[`typed_data`]|-|1.3.0|1.3.0|
|[`uuid`]|-|3.0.6|3.0.6|
|[`vm_service`]|-|8.2.0|8.2.0|
|[`watcher`]|-|1.0.1|1.0.1|
|[`web_socket_channel`]|-|2.1.0|2.1.0|
|[`webkit_inspection_protocol`]|-|1.0.0|1.0.0|
|[`xml`]|-|5.3.1|5.3.1|
|[`yaml`]|-|3.1.0|3.1.0|
</details>

To reproduce run `dart pub outdated --no-dev-dependencies --up-to-date --no-dependency-overrides`.

[`amazon_cognito_identity_dart_2`]: https://pub.dev/packages/amazon_cognito_identity_dart_2
[`aws_lambda_dart_runtime`]: https://pub.dev/packages/aws_lambda_dart_runtime
[`aws_s3_api`]: https://pub.dev/packages/aws_s3_api
[`collection`]: https://pub.dev/packages/collection
[`equatable`]: https://pub.dev/packages/equatable
[`http`]: https://pub.dev/packages/http
[`injector`]: https://pub.dev/packages/injector
[`json_annotation`]: https://pub.dev/packages/json_annotation
[`matcher`]: https://pub.dev/packages/matcher
[`meta`]: https://pub.dev/packages/meta
[`mocktail`]: https://pub.dev/packages/mocktail
[`path`]: https://pub.dev/packages/path
[`_fe_analyzer_shared`]: https://pub.dev/packages/_fe_analyzer_shared
[`args`]: https://pub.dev/packages/args
[`async`]: https://pub.dev/packages/async
[`boolean_selector`]: https://pub.dev/packages/boolean_selector
[`charcode`]: https://pub.dev/packages/charcode
[`clock`]: https://pub.dev/packages/clock
[`convert`]: https://pub.dev/packages/convert
[`crypto`]: https://pub.dev/packages/crypto
[`file`]: https://pub.dev/packages/file
[`frontend_server_client`]: https://pub.dev/packages/frontend_server_client
[`glob`]: https://pub.dev/packages/glob
[`http_multi_server`]: https://pub.dev/packages/http_multi_server
[`http_parser`]: https://pub.dev/packages/http_parser
[`intl`]: https://pub.dev/packages/intl
[`io`]: https://pub.dev/packages/io
[`js`]: https://pub.dev/packages/js
[`logging`]: https://pub.dev/packages/logging
[`mime`]: https://pub.dev/packages/mime
[`node_preamble`]: https://pub.dev/packages/node_preamble
[`package_config`]: https://pub.dev/packages/package_config
[`petitparser`]: https://pub.dev/packages/petitparser
[`pool`]: https://pub.dev/packages/pool
[`pub_semver`]: https://pub.dev/packages/pub_semver
[`shared_aws_api`]: https://pub.dev/packages/shared_aws_api
[`shelf`]: https://pub.dev/packages/shelf
[`shelf_packages_handler`]: https://pub.dev/packages/shelf_packages_handler
[`shelf_static`]: https://pub.dev/packages/shelf_static
[`shelf_web_socket`]: https://pub.dev/packages/shelf_web_socket
[`source_map_stack_trace`]: https://pub.dev/packages/source_map_stack_trace
[`source_maps`]: https://pub.dev/packages/source_maps
[`source_span`]: https://pub.dev/packages/source_span
[`stack_trace`]: https://pub.dev/packages/stack_trace
[`stream_channel`]: https://pub.dev/packages/stream_channel
[`string_scanner`]: https://pub.dev/packages/string_scanner
[`term_glyph`]: https://pub.dev/packages/term_glyph
[`test_api`]: https://pub.dev/packages/test_api
[`test_core`]: https://pub.dev/packages/test_core
[`typed_data`]: https://pub.dev/packages/typed_data
[`uuid`]: https://pub.dev/packages/uuid
[`vm_service`]: https://pub.dev/packages/vm_service
[`watcher`]: https://pub.dev/packages/watcher
[`web_socket_channel`]: https://pub.dev/packages/web_socket_channel
[`webkit_inspection_protocol`]: https://pub.dev/packages/webkit_inspection_protocol
[`xml`]: https://pub.dev/packages/xml
[`yaml`]: https://pub.dev/packages/yaml


### [*] 10/10 points: Package supports latest stable Dart and Flutter SDKs


## ✓ Support sound null safety (20 / 20)
### [*] 20/20 points: Package and dependencies are fully migrated to null safety!


Points: 100/120.
