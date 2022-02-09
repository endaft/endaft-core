import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:endaft_core/client.dart';

void main() {
  group('Error Tests', () {
    test('Verifies AppError Works As Expected', () {
      final message = 'testing';
      final stack = StackTrace.current;
      final error = AppError(message, stack);

      expect(error, isNotNull);
      expect(error, isA<Exception>());
      expect(error.message, equals(message));
      expect(error.stackTrace, stack);
      expect(error.context, isEmpty);
      expect(error.toString(), startsWith(error.runtimeType.toString()));
      expect(error.toString(), endsWith(stack.toString()));
    });

    test('Verifies AppError Becomes Response As Expected', () {
      final message = 'testing';
      final stack = StackTrace.current;
      final error = AppError(message, stack);
      final response = error.toResponse();

      expect(response, isNotNull);
      expect(response, isA<ResponseBase>());
      expect(response.type, equals(error.runtimeType.toString()));
      expect(response.messages, contains(message));
      expect(response.statusCode, HttpStatus.internalServerError);
      expect(response.context, equals(error.context));
      expect(response.stackTrace, equals(error.stackTrace!.toStringArray()));
    });

    test('Verifies HttpError fromResponse Works As Expected', () {
      final reason = 'Bad Request';
      final reqUri = Uri.parse('http://testing');
      final response = Response(
        '',
        400,
        reasonPhrase: reason,
        request: Request('GET', reqUri),
      );
      final error = HttpError.fromResponse(response);

      expect(error, isNotNull);
      expect(error, isA<HttpError>());
      expect(error.uri, equals(reqUri));
      expect(error.message, reason);
      expect(error.statusCode, equals(400));
    });

    test(
        'Verifies HttpError fromResponse Sans Reason Or Request Works As Expected',
        () {
      final response = Response('', 400);
      final error = HttpError.fromResponse(response);
      final reqUri = Uri.parse('http://unknown_url');
      final reason = 'HTTP Status 400';

      expect(error, isNotNull);
      expect(error, isA<HttpError>());
      expect(error.uri, equals(reqUri));
      expect(error.message, reason);
      expect(error.statusCode, equals(400));
    });

    test('Verifies SecurityError Works As Expected', () {
      final message = 'testing';
      final error = SecurityError(message);

      expect(error, isNotNull);
      expect(error.message, equals(message));
    });

    test('Verifies SecurityError.noUser Works As Expected', () {
      final error = SecurityError.noUser();

      expect(error, isNotNull);
      expect(error.message, isNotNull);
      expect(error.message, isNotEmpty);
    });

    test('Verifies BadContextError Works As Expected', () {
      final key = 'foo';
      final message = 'testing';
      final error = BadContextError(message, key);

      expect(error, isNotNull);
      expect(error.message, endsWith(message));
      expect(error.context, containsValue(key));
    });

    test('Verifies BadContextError.missingKey Works As Expected', () {
      final key = 'foo';
      final message = 'Missing key';
      final error = BadContextError.missingKey(key);

      expect(error, isNotNull);
      expect(error.message, endsWith(message));
      expect(error.context, containsValue(key));
    });

    test('Verifies MissingConfigError Works As Expected', () {
      final name = 'foo';
      final error = MissingConfigError(name);

      expect(error, isNotNull);
      expect(error.message, contains('configuration value is missing'));
      expect(error.context, containsValue(name));
    });

    test('Verifies HttpError Works As Expected', () {
      final message = 'Server Error';
      final uri = Uri.parse('http://testing');
      final statusCode = 500;
      final error = HttpError(
        uri: uri,
        message: message,
        statusCode: statusCode,
      );

      expect(error, isNotNull);
      expect(error.uri, equals(uri));
      expect(error.message, equals(message));
      expect(error.statusCode, equals(statusCode));
      expect(error.context, containsValue(uri));
      expect(error.context, containsValue(statusCode));
    });

    test('Verifies IntegrationError Works As Expected', () {
      final message = 'testing';
      final serviceCode = 'foo';
      final serviceName = 'coolStuff';
      final providerName = 'test';
      final serviceMessage = 'we failed';
      final error = IntegrationError(
        message,
        serviceCode: serviceCode,
        serviceName: serviceName,
        providerName: providerName,
        serviceMessage: serviceMessage,
        stackTrace: StackTrace.current,
      );

      expect(error, isNotNull);
      expect(error.message, endsWith(message));
      expect(error.context, isNotNull);
      expect(
          error.context.values,
          containsAll(<String>[
            serviceCode,
            serviceName,
            providerName,
            serviceMessage,
          ]));
    });
  });
}
