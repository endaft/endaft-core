import 'dart:async';
import 'dart:collection';

import 'package:mocktail/mocktail.dart';
import 'package:aws_lambda_dart_runtime/runtime/event.dart';
import 'package:aws_lambda_dart_runtime/runtime/context.dart';
import 'package:aws_lambda_dart_runtime/runtime/runtime.dart';
import 'package:aws_lambda_dart_runtime/runtime/exception.dart';
import 'package:aws_lambda_dart_runtime/events/apigateway_event.dart';

export 'package:aws_lambda_dart_runtime/runtime/event.dart';
export 'package:aws_lambda_dart_runtime/runtime/context.dart';
export 'package:aws_lambda_dart_runtime/runtime/runtime.dart';
export 'package:aws_lambda_dart_runtime/runtime/exception.dart';
export 'package:aws_lambda_dart_runtime/events/apigateway_event.dart';

typedef MockRuntimeCallback = void Function(AwsApiGatewayResponse resp);

class _MockRuntimeHandler {
  final Type type;
  final dynamic handler;

  const _MockRuntimeHandler(this.type, this.handler) : assert(handler != null);
}

class _MockInvocation<T> {
  _MockInvocation(this.context, this.eventJson, this.callback);

  final Context context;
  final Map<String, dynamic> eventJson;
  final Completer<T> callback;
}

class MockRuntime extends Mock implements Runtime {
  MockRuntime._privateConstructor();
  static final MockRuntime _instance = MockRuntime._privateConstructor();
  factory MockRuntime() => _instance;
  final Map<String, _MockRuntimeHandler> _handlers = {};
  final Queue<_MockInvocation> _invocations = Queue<_MockInvocation>();

  Future<T> queue<T>(
    Context context,
    Map<String, dynamic> event,
  ) {
    final callback = Completer<T>();
    _invocations.add(_MockInvocation<T>(context, event, callback));

    return callback.future;
  }

  @override
  Handler<E> registerHandler<E>(String name, Handler<E> handler) {
    _handlers[name] = _MockRuntimeHandler(E, handler);
    return handler;
  }

  @override
  void invoke() async {
    if (_invocations.isEmpty) return;

    final invocation = _invocations.removeFirst();
    final context = invocation.context;
    final callback = invocation.callback;
    final func = _handlers[context.handler];
    if (func == null) {
      return callback.completeError(
        RuntimeException(
          'No handler with name "${context.handler}" registered in runtime!',
        ),
      );
    }
    final json = invocation.eventJson;
    final dynamic event = Event.fromHandler<dynamic>(func.type, json);
    final dynamic result = await func.handler(context, event);
    callback.complete(result);
  }
}
