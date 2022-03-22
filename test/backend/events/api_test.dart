import 'package:test/test.dart';
import 'package:endaft_core/server_test.dart';

import '../../utils.dart';

void main() {
  group('API Gateway Event Tests', () {
    test('Verifies ApiGatewayEvent Works As Expected', () {
      late final ApiGatewayEvent event;
      expect(() {
        event = makeApiEvent();
      }, returnsNormally);
      expect(event, isNotNull);

      expect(event.hasEnv('foo'), isFalse);
      expect(event.getEnv('foo'), isNull);
      expect(event.getEnvNum('foo'), isNull);
      expect(event.getEnvBool('foo'), isNull);
      expect(event.getEnv('foo', 'bar'), equals('bar'));
      expect(event.getEnvNum('foo', 42), equals(42));
      expect(event.getEnvBool('foo', true), isTrue);

      expect(event.hasHeader('foo'), isFalse);
      expect(event.getHeader('foo'), isNull);
      expect(event.getHeader('foo', 'bar'), equals('bar'));
    });

    test('Verifies getHeader Works As Expected', () {
      late final ApiGatewayEvent event;
      expect(() {
        event = makeApiEvent(headers: <String, String>{
          'Host': 'test.my-great.app',
        });
      }, returnsNormally);
      expect(event, isNotNull);

      expect(event.hasHeader('Host'), isTrue);
      expect(event.getHeader('Host'), isNotNull);
      expect(
        event.getHeader('Host', 'my-domain.tld'),
        isNot(equals('my-domain.tld')),
      );
    });

    test('Verifies getEnv* Works As Expected', () {
      final tableName = 'table_${randomId(16)}';
      late final ApiGatewayEvent event;
      expect(() {
        event = makeApiEvent(headers: <String, String>{
          'X-Env-TableName': tableName,
          'X-Env-Timeout': 30.toString(),
          'X-Env-Enabled': true.toString(),
        });
      }, returnsNormally);
      expect(event, isNotNull);

      expect(event.hasEnv('TableName'), isTrue);
      expect(event.getEnv('TableName'), isNotNull);
      expect(
        event.getEnv('TableName', 'foo'),
        isNot(equals('foo')),
      );
      expect(
        event.getEnv('TableName', 'foo'),
        equals(tableName),
      );

      expect(event.hasEnv('Timeout'), isTrue);
      expect(event.getEnvNum('Timeout'), isNotNull);
      expect(
        event.getEnvNum('Timeout', 42),
        isNot(equals(42)),
      );
      expect(
        event.getEnvNum('Timeout', 42),
        equals(30),
      );

      expect(event.hasEnv('Enabled'), isTrue);
      expect(event.getEnvBool('Enabled'), isNotNull);
      expect(
        event.getEnvBool('Enabled', false),
        isNot(isFalse),
      );
      expect(
        event.getEnvBool('Enabled', false),
        isTrue,
      );
    });

    test('API Gateway Objects (De)Serializes JSON As Expected', () {
      final now = DateTime.now();
      final domainPrefix = 'test';
      final domainName = 'test.my-great.app';

      testJson<ApiGatewayAuthorizer>(
        ctor: () => ApiGatewayAuthorizer(claims: {}, scopes: []),
        toJson: (model) => model.toJson(),
        fromJson: ApiGatewayAuthorizer.fromJson,
      );

      testJson<ApiGatewayRequestContext>(
        ctor: () => ApiGatewayRequestContext(
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
        toJson: (model) => model.toJson(),
        fromJson: ApiGatewayRequestContext.fromJson,
      );

      testJson<ApiGatewayEvent>(
        ctor: () => ApiGatewayEvent(
          version: '2.0',
          routeKey: r'$default',
          rawPath: '/',
          rawQueryString: '',
          cookies: ["cookie1", "cookie2"],
          headers: {"header1": "value1", "header2": "value1,value2"},
          queryStringParameters: {
            "parameter1": "value1,value2",
            "parameter2": "value"
          },
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
          body: "Hello from Lambda",
          pathParameters: {"parameter1": "value1"},
          isBase64Encoded: false,
          stageVariables: {
            "stageVariable1": "value1",
            "stageVariable2": "value2"
          },
        ),
        toJson: (model) => model.toJson(),
        fromJson: ApiGatewayEvent.fromJson,
      );
    });
  });
}
