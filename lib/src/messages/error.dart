import 'dart:io' if (dart.library.html) 'dart:html' show HttpStatus;

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import './base.dart';
import '../common/extensions/all.dart';

part 'error.g.dart';

@immutable
@JsonSerializable()
class ErrorResponse extends ResponseBase {
  ErrorResponse({
    bool error = true,
    required List<String> messages,
    required this.type,
    int statusCode = HttpStatus.internalServerError,
    this.context,
    this.stackTrace,
  }) : super(error: error, messages: messages, statusCode: statusCode);

  @JsonKey(name: "__type")
  final String type;

  final Iterable<String>? stackTrace;
  final Map<String, dynamic>? context;

  @override
  List<Object?> get props => [...super.props, type, stackTrace, context];

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

class AppError implements Exception {
  AppError(this.message, [this.stackTrace]) : super();

  /// The exception message, this should not use interpolation.
  /// Store exception context in [context], appropriately.
  final String message;

  /// The exception stack trace
  final StackTrace? stackTrace;

  /// The context around the exception. Use this for scoped-values and states
  /// that may have contributed to the exception and might be useful in reproduction.
  Map<String, dynamic> get context => <String, dynamic>{};

  ErrorResponse toResponse([int statusCode = HttpStatus.internalServerError]) =>
      ErrorResponse(
          type: runtimeType.toString(),
          messages: [message],
          statusCode: statusCode,
          context: context,
          stackTrace: stackTrace?.toStringArray());

  @override
  String toString() {
    final trace = (stackTrace ?? '').toString();
    final clues = context.entries
        .map((e) => '${e.key}: ${e.value.toString()}')
        .join('\n');
    return "${runtimeType.toString()}: $message\n${[clues, trace].join('\n')}";
  }
}

class SecurityError extends AppError {
  SecurityError(String message, [StackTrace? stackTrace])
      : super(message, stackTrace);

  factory SecurityError.noUser() => SecurityError('Missing user data');
}

class BadContextError extends AppError {
  BadContextError(String reason, this.key, [StackTrace? stackTrace])
      : super('Bad context: $reason', stackTrace);

  final String key;

  @override
  get context => <String, dynamic>{'key': key};

  factory BadContextError.missingKey(String key) =>
      BadContextError('Missing key', key);
}

class IntegrationError extends AppError {
  IntegrationError(
    String message, {
    this.providerName,
    this.serviceName,
    this.serviceCode,
    this.serviceMessage,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);

  final String? serviceName;
  final String? serviceCode;
  final String? providerName;
  final String? serviceMessage;

  @override
  Map<String, dynamic> get context => <String, dynamic>{
        "providerName": providerName,
        "serviceName": serviceName,
        "serviceMessage": serviceMessage,
        "serviceCode": serviceCode,
      };
}

class HttpError extends AppError {
  HttpError({
    required String message,
    required this.uri,
    required this.statusCode,
  }) : super(message, StackTrace.current);

  final Uri uri;
  final int statusCode;

  factory HttpError.fromResponse(Response response) {
    return HttpError(
      message: response.reasonPhrase ?? 'HTTP Status ${response.statusCode}',
      uri: response.request?.url ?? Uri(scheme: 'http', host: 'unknown_url'),
      statusCode: response.statusCode,
    );
  }

  @override
  Map<String, dynamic> get context => <String, dynamic>{
        'uri': uri,
        'statusCode': statusCode,
      };
}

class MissingConfigError extends AppError {
  MissingConfigError(this.name)
      : super(
          'An expected configuration value is missing.',
          StackTrace.current,
        );

  final String name;

  @override
  Map<String, dynamic> get context => <String, dynamic>{'name': name};
}
