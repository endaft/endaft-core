library endaft.core.server_test;

import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:collection';

import 'package:matcher/matcher.dart';
import 'package:path/path.dart' as path;
import 'package:aws_lambda_dart_runtime/runtime/context.dart';

import 'server.dart';
export 'server.dart';
export 'matchers.dart';
export 'src/common/config.dart';
export 'src/mocks/backend/all.dart';

final _rnd = Random(DateTime.now().microsecondsSinceEpoch);
int _rndN(int min, int max) => (_rnd.nextInt(max - min) + min).floor();
String _rndA() => String.fromCharCode(_rndN(65, 90));
String _getRandomId([int size = 32]) =>
    List.generate(size, (index) => _rndA()).join();
dynamic _getIacData() => File('iac.json').existsSync()
    ? jsonDecode(File('iac.json').readAsStringSync())
    : null;

Context getFakeContext({bool useIacFile = true, String handler = 'bootstrap'}) {
  final dynamic iac = useIacFile
      ? _getIacData()
      : <String, dynamic>{
          'handler': handler,
          'memory': 128,
        };
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
    'version': '2',
    'routeKey': 'default',
    'rawPath': requestPath,
    'rawQueryString': '',
    'cookies': <dynamic>[],
    'resource': resourcePath,
    'requestContext': ApiGatewayRequestContext(
      accountId: randomId(),
      apiId: randomId(),
      authorizer: <String, ApiGatewayAuthorizer>{},
      domainName: 'testing.tld',
      domainPrefix: '',
      http: <String, String>{},
      requestId: randomId(),
      routeKey: 'default',
      stage: 'test',
      time: DateTime.now(),
      timeEpoch: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    ).toJson(),
    'path': requestPath,
    'httpMethod': httpMethod.name.toUpperCase(),
    'queryStringParameters': queryString,
    'stageVariables': stageVars,
    'pathParameters': pathParams,
    'body': jsonEncode(body),
    'isBase64Encoded': false,
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

TestServerConfig getTestConfig([Map<String, String>? overrides]) {
  return TestServerConfig(getTestEnv(overrides));
}

CloudFrontOriginRequestEvent makeOriginEvent({
  CloudFrontHeaders? originCustomHeaders,
  CloudFrontHeaders? requestCustomHeaders,
  String? requestUri,
  String? requestHost,
}) {
  final domainName = '${randomId()}-test.cloudfront.aws.com';
  return CloudFrontOriginRequestEvent(
    records: <CloudFrontRecords>[
      CloudFrontRecords(
        cf: CloudFront(
          config: CloudFrontConfig(
            distributionDomainName: domainName,
            distributionId: randomId(),
            eventType: 'origin-request',
            requestId: randomId(32),
          ),
          request: CloudFrontRequest(
            uri: requestUri ?? '/',
            method: 'GET',
            queryString: '',
            clientIp: '127.0.0.1',
            origin: <String, CloudFrontOrigin>{
              'custom': CloudFrontOrigin(
                customHeaders: originCustomHeaders ??
                    CloudFrontHeaders(
                      headers: {},
                    ),
                domainName: requestHost ?? domainName,
                keepAliveTimeout: 30,
                path: requestUri ?? '/',
                port: 80,
                protocol: 'https',
                readTimeout: 30,
                sslProtocols: <String>['TLS_1.2'],
              )
            },
            body: CloudFrontRequestBody(
              data: '',
              inputTruncated: false,
              action: CloudFrontBodyAction.readOnly,
              encoding: CloudFrontBodyEncoding.text,
            ),
            headers: CloudFrontHeaders(
              headers: <String, List<Map<String, String>>>{
                'Host': <Map<String, String>>[
                  <String, String>{'Host': requestHost ?? domainName},
                ],
                ...requestCustomHeaders?.headers ?? {},
              },
            ),
          ),
        ),
      )
    ],
  );
}

ApiGatewayEvent makeApiEvent({
  String body = '',
  bool isBase64Encoded = false,
  List<String> cookies = const [],
  Map<String, String> headers = const {},
  Map<String, String> pathParameters = const {},
  Map<String, String> stageVariables = const {},
  Map<String, String> queryStringParameters = const {},
}) {
  final now = DateTime.now();
  final domainPrefix = 'test';
  final domainName = 'test.my-great.app';

  return ApiGatewayEvent(
    version: '2.0',
    routeKey: r'$default',
    rawPath: '/',
    rawQueryString: '',
    cookies: cookies,
    headers: headers,
    queryStringParameters: queryStringParameters,
    requestContext: ApiGatewayRequestContext(
      accountId: randomId(),
      apiId: randomId(6),
      authorizer: <String, ApiGatewayAuthorizer>{
        'cognito': ApiGatewayAuthorizer(claims: {}, scopes: []),
      },
      domainName: domainName,
      domainPrefix: domainPrefix,
      http: <String, String>{
        "method": "POST",
        "path": "/my/path",
        "protocol": "HTTP/1.1",
        "sourceIp": "IP",
        "userAgent": "agent",
      },
      requestId: randomId(),
      routeKey: r'$default',
      stage: 'test',
      time: now,
      timeEpoch: (now.millisecondsSinceEpoch / 1000).floor(),
    ),
    body: body,
    isBase64Encoded: isBase64Encoded,
    pathParameters: pathParameters,
    stageVariables: stageVariables,
  );
}
