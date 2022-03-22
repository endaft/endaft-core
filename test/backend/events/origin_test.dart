import 'package:test/test.dart';
import 'package:endaft_core/server_test.dart';

import '../../utils.dart';

void main() {
  group('CloudFront Origin Event Tests', () {
    test('Verifies CloudFrontOriginRequestEvent Works As Expected', () {
      late final CloudFrontOriginRequestEvent event;
      expect(() {
        event = makeOriginEvent();
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
      late final CloudFrontOriginRequestEvent event;
      expect(() {
        event = makeOriginEvent();
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
      late final CloudFrontOriginRequestEvent event;
      expect(() {
        event = makeOriginEvent(
          originCustomHeaders: CloudFrontHeaders(
            headers: <String, List<Map<String, String>>>{
              'X-Env-TableName': <Map<String, String>>[
                <String, String>{'X-Env-TableName': tableName},
              ],
              'X-Env-Timeout': <Map<String, String>>[
                <String, String>{'X-Env-Timeout': 30.toString()},
              ],
              'X-Env-Enabled': <Map<String, String>>[
                <String, String>{'X-Env-Enabled': true.toString()},
              ],
            },
          ),
        );
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

    test('CloudFront Objects (De)Serializes JSON As Expected', () {
      testJson<CloudFrontHeaders>(
        ctor: () => CloudFrontHeaders(
          headers: <String, List<Map<String, String>>>{
            'Host': <Map<String, String>>[
              <String, String>{'Host': 'test.my-great.app'},
            ],
          },
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontHeaders.fromJson,
      );

      testJson<CloudFrontRequestBody>(
        ctor: () => CloudFrontRequestBody(
          data: '',
          inputTruncated: false,
          action: CloudFrontBodyAction.readOnly,
          encoding: CloudFrontBodyEncoding.text,
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontRequestBody.fromJson,
      );

      testJson<CloudFrontRequest>(
        ctor: () => CloudFrontRequest(
          uri: '/',
          method: 'GET',
          queryString: '',
          clientIp: '127.0.0.1',
          origin: <String, CloudFrontOrigin>{
            'custom': CloudFrontOrigin(
              customHeaders: CloudFrontHeaders(
                headers: {},
              ),
              domainName: 'test.my-great.app',
              keepAliveTimeout: 30,
              path: '/',
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
                <String, String>{'Host': 'test.my-great.app'},
              ],
            },
          ),
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontRequest.fromJson,
      );

      testJson<CloudFrontConfig>(
        ctor: () => CloudFrontConfig(
          distributionDomainName: 'test.my-great.app',
          distributionId: randomId(),
          eventType: 'origin-request',
          requestId: randomId(32),
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontConfig.fromJson,
      );

      testJson<CloudFront>(
        ctor: () => CloudFront(
          config: CloudFrontConfig(
            distributionDomainName: 'test.my-great.app',
            distributionId: randomId(),
            eventType: 'origin-request',
            requestId: randomId(32),
          ),
          request: CloudFrontRequest(
            uri: '/',
            method: 'GET',
            queryString: '',
            clientIp: '127.0.0.1',
            origin: <String, CloudFrontOrigin>{
              'custom': CloudFrontOrigin(
                customHeaders: CloudFrontHeaders(
                  headers: {},
                ),
                domainName: 'test.my-great.app',
                keepAliveTimeout: 30,
                path: '/',
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
                  <String, String>{'Host': 'test.my-great.app'},
                ],
              },
            ),
          ),
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFront.fromJson,
      );

      testJson<CloudFrontRecords>(
        ctor: () => CloudFrontRecords(
          cf: CloudFront(
            config: CloudFrontConfig(
              distributionDomainName: 'test.my-great.app',
              distributionId: randomId(),
              eventType: 'origin-request',
              requestId: randomId(32),
            ),
            request: CloudFrontRequest(
              uri: '/',
              method: 'GET',
              queryString: '',
              clientIp: '127.0.0.1',
              origin: <String, CloudFrontOrigin>{
                'custom': CloudFrontOrigin(
                  customHeaders: CloudFrontHeaders(
                    headers: {},
                  ),
                  domainName: 'test.my-great.app',
                  keepAliveTimeout: 30,
                  path: '/',
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
                    <String, String>{'Host': 'test.my-great.app'},
                  ],
                },
              ),
            ),
          ),
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontRecords.fromJson,
      );

      testJson<CloudFrontOriginRequestEvent>(
        ctor: () => CloudFrontOriginRequestEvent(
          records: <CloudFrontRecords>[
            CloudFrontRecords(
              cf: CloudFront(
                config: CloudFrontConfig(
                  distributionDomainName: 'test.my-great.app',
                  distributionId: randomId(),
                  eventType: 'origin-request',
                  requestId: randomId(32),
                ),
                request: CloudFrontRequest(
                  uri: '/',
                  method: 'GET',
                  queryString: '',
                  clientIp: '127.0.0.1',
                  origin: <String, CloudFrontOrigin>{
                    'custom': CloudFrontOrigin(
                      customHeaders: CloudFrontHeaders(
                        headers: {},
                      ),
                      domainName: 'test.my-great.app',
                      keepAliveTimeout: 30,
                      path: '/',
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
                        <String, String>{'Host': 'test.my-great.app'},
                      ],
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontOriginRequestEvent.fromJson,
      );

      testJson<CloudFrontOriginResponse>(
        ctor: () => CloudFrontOriginResponse(
          body: 'foo',
          bodyEncoding: CloudFrontBodyEncoding.text,
          headers: CloudFrontHeaders(
            headers: <String, List<Map<String, String>>>{
              'Etag': <Map<String, String>>[
                <String, String>{'etag': randomId(18)},
              ],
            },
          ),
          status: 200,
          statusDescription: 'This is the droid you are looking for.',
        ),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontOriginResponse.fromJson,
      );

      testJson<CloudFrontOriginResponse>(
        ctor: () => CloudFrontOriginResponse(),
        toJson: (model) => model.toJson(),
        fromJson: CloudFrontOriginResponse.fromJson,
      );
    });
  });
}
