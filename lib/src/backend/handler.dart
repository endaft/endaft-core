import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:aws_s3_api/s3-2006-03-01.dart';

import 'all.dart';

/// The base API Handler implementation for fulfilling requests.
class BaseAppApiHandler<TConfig extends BaseServerConfig> {
  BaseAppApiHandler({
    required this.config,
    required this.httpClient,
  });

  /// The [TConfig] instance from the registry.
  final TConfig config;

  /// The [http.Client] used for making requests.
  /// This can be used for custom HTTP calls by a derived API.
  final http.Client httpClient;

  static MapEntry<String, List<Map<String, String>>>? _headerFrom({
    required String name,
    required String? value,
  }) {
    if (value == null || value.isEmpty) return null;
    return MapEntry<String, List<Map<String, String>>>(
        name, <Map<String, String>>[
      {
        name: value,
      }
    ]);
  }

  Future<AwsClientCredentials?> _credentialsProvider({
    http.Client? client,
  }) async {
    final accessKey = config.tryGet('AWS_ACCESS_KEY_ID');
    final secretKey = config.tryGet('AWS_SECRET_ACCESS_KEY');
    final sessionToken = config.tryGet('AWS_SESSION_TOKEN');
    if (accessKey != null && secretKey != null) {
      return AwsClientCredentials(
        accessKey: accessKey,
        secretKey: secretKey,
        sessionToken: sessionToken,
      );
    }
    return null;
  }

  Future<CloudFrontOriginResponse> serveSpaFrom({
    required CloudFrontOriginRequestEvent event,
    String defaultFileName = 'index.html',
  }) async {
    final bool canServe = event.hasHeader('Host') &&
        event.hasEnv('BASE_DOMAIN') &&
        event.hasEnv('BUCKET_NAME') &&
        event.hasEnv('BUCKET_REGION');
    if (!canServe) {
      throw StateError("Cannot serve static content from this event. It's "
          "missing one or more required aspects: Host header, BASE_DOMAIN, "
          "BUCKET_NAME, or BUCKET_REGION.");
    }

    final request = event.records.first.cf.request;
    final String hostName = event.getHeader('Host')!;
    final String baseName = event.getEnv('BASE_DOMAIN')!;
    final String bucketName = event.getEnv('BUCKET_NAME')!;
    final String bucketRegion = event.getEnv('BUCKET_REGION')!;
    final int subSize = (hostName.length - baseName.length);
    final String subName = subSize > 0 ? hostName.substring(0, subSize) : 'www';
    final String safeUri = request.uri.startsWith('/')
        ? request.uri.replaceFirst(r'/', '')
        : request.uri;
    final String reqExt = path.extension(request.uri);
    final String reqFileName = reqExt.isEmpty ? defaultFileName : '';
    final String bucketPath = path.join(subName, safeUri, reqFileName);
    final String spaBucketPath = path.join(subName, defaultFileName);

    late final int status;
    late final Encoding enc;
    late final GetObjectOutput s3Resp;

    final S3 s3 = S3(
      region: bucketRegion,
      client: httpClient,
      credentialsProvider: _credentialsProvider,
    );
    try {
      s3Resp = await s3.getObject(
        bucket: bucketName,
        key: bucketPath,
      );
      enc = Encoding.getByName(s3Resp.contentEncoding) ?? utf8;
      status = 200;
    } on NoSuchBucket {
      status = 500;
      throw StateError("The bucket doesn't exist or is not accessible.");
    } on NoSuchKey {
      if (bucketPath != spaBucketPath) {
        return serveSpaFrom(event: event.redirectTo(defaultFileName));
      }
      status = 404;
      throw StateError("The item doesn't exist or is not accessible.");
    }

    return CloudFrontOriginResponse(
      status: status,
      statusDescription: getHttpReason(status),
      body: s3Resp.body != null && s3Resp.body!.isNotEmpty
          ? enc.decode(s3Resp.body!)
          : null,
      bodyEncoding: CloudFrontBodyEncoding.text,
      headers: CloudFrontHeaders(
        headers: Map<String, List<Map<String, String>>>.fromEntries(
          [
            _headerFrom(
              name: 'Content-Disposition',
              value: s3Resp.contentDisposition,
            ),
            _headerFrom(
              name: 'Cache-Control',
              value: s3Resp.cacheControl,
            ),
            _headerFrom(
              name: 'Content-Encoding',
              value: s3Resp.contentEncoding,
            ),
            _headerFrom(
              name: 'Content-Language',
              value: s3Resp.contentLanguage,
            ),
            _headerFrom(
              name: 'Content-Length',
              value: s3Resp.contentLength?.toString(),
            ),
            _headerFrom(
              name: 'Content-Type',
              value: s3Resp.contentType,
            )
          ].whereType<MapEntry<String, List<Map<String, String>>>>().toList(),
        ),
      ),
    );
  }
}
