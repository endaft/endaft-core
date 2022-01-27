library endaft.core.server_test;

import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:collection';

import 'package:path/path.dart' as path;
import 'package:aws_lambda_dart_runtime/runtime/context.dart';

import 'server.dart';
export 'matchers.dart';
export 'src/common/config.dart';
export 'src/mocks/backend/all.dart';

final _rnd = Random(DateTime.now().microsecondsSinceEpoch);
int _rndN(int min, int max) => (_rnd.nextInt(max - min) + min).floor();
String _rndA() => String.fromCharCode(_rndN(65, 90));
String _getRandomId([int size = 32]) =>
    List.generate(size, (index) => _rndA()).join();
dynamic _getIacData() => jsonDecode(File('iac.json').readAsStringSync());

Context getFakeContext() {
  final dynamic iac = _getIacData();
  final funcName = path.basename(Directory.current.path);
  return Context(
    requestId: _getRandomId(18),
    handler: iac['handler'].toString(),
    functionName: funcName,
    functionMemorySize: iac['memory'].toString(),
    logGroupName: 'test/lambdas',
    logStreamName: 'test/lambdas/$funcName',
    region: Platform.localHostname,
    accessKey: _getRandomId(),
    secretAccessKey: _getRandomId(),
    sessionToken: _getRandomId(),
    invokedFunction: funcName,
    executionEnv: 'test',
  );
}

Map<String, dynamic> makeEventData({
  Map<String, dynamic> body = const <String, dynamic>{},
  Map<String, dynamic> headers = const <String, dynamic>{},
  String resourcePath = '/',
  String requestPath = '/',
  HttpMethod httpMethod = HttpMethod.get,
  Map<String, dynamic> queryString = const <String, dynamic>{},
  Map<String, dynamic> stageVars = const <String, dynamic>{},
  Map<String, dynamic> pathParams = const <String, dynamic>{},
  bool fakeAuth = true,
}) {
  final fullHeaders = <String, dynamic>{
    ...headers,
    ...(fakeAuth ? getFakeAuthHeaders() : <String, dynamic>{})
  };
  var result = <String, dynamic>{
    'resource': resourcePath,
    'path': requestPath,
    'httpMethod': httpMethod.name.toUpperCase(),
    'queryStringParameters': queryString,
    'stageVariables': stageVars,
    'pathParameters': pathParams,
    'body': jsonEncode(body),
    'headers': fullHeaders,
  };
  return result;
}

Map<String, dynamic> getFakeAuthHeaders() {
  final userId = DateTime.now().millisecondsSinceEpoch.toString();
  final userName = 'user-$userId';
  final userAddress = <String, dynamic>{
    'formatted': '123 Main St, Austin, Texas, US',
    'street_address': '123 Main St',
    'locality': 'Austin',
    'region': 'Texas',
    'postal_code': '78601',
    'country': 'US',
  };
  return <String, dynamic>{
    'X-User-Id': userId,
    'X-User-Email': '$userName@daft.dev',
    'X-User-Username': userName,
    'X-User-Nickname': userId,
    'X-User-GivenName': 'Given',
    'X-User-FamilyName': 'Family',
    'X-User-PhoneNumber': '+1 123-456-7890',
    'X-User-BirthDate': '1970-01-01',
    'X-User-ZoneInfo': 'America/Chicago',
    'X-User-Locale': 'en-US',
    'X-User-Picture':
        'http://getdrawings.com/free-icon-bw/people-icon-vector-free-22.png',
    'X-User-Address': jsonEncode(userAddress),
    'X-User-LastUpdated': DateTime.now().toIso8601String(),
  };
}

Map<String, String> getTestEnv([Map<String, String>? overrides]) {
  return UnmodifiableMapView(Map<String, String>.from(Platform.environment)
    ..addAll({
      'AWS_REGION': 'us-east-1',
      'DATA_TABLE_NAME': 'my-great-app-test-data'
    })
    ..addAll(overrides ?? {}));
}

class TestServerConfig extends BaseServerConfig {
  TestServerConfig([Map<String, String>? env])
      : super(env ?? <String, String>{});
}

BaseServerConfig getTestConfig([Map<String, String>? overrides]) {
  return TestServerConfig(getTestEnv(overrides));
}
