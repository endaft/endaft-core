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

class _MockInvocation {
  _MockInvocation(this.context, this.eventJson, this.callback);

  final Context context;
  final Map<String, dynamic> eventJson;
  final Completer<AwsApiGatewayResponse> callback;
}

class MockRuntime extends Mock implements Runtime {
  MockRuntime._privateConstructor();
  static final MockRuntime _instance = MockRuntime._privateConstructor();
  factory MockRuntime() => _instance;
  final Map<String, _MockRuntimeHandler> _handlers = {};
  final Queue<_MockInvocation> _invocations = Queue<_MockInvocation>();

  Future<AwsApiGatewayResponse> queue(
    Context context,
    Map<String, dynamic> event,
  ) {
    final callback = Completer<AwsApiGatewayResponse>();
    _invocations.add(_MockInvocation(context, event, callback));

    return callback.future;
  }

  @override
  Handler<E> registerHandler<E>(String name, Handler<E> handler) {
    _handlers[name] = _MockRuntimeHandler(E, handler);
    return handler;
  }

  @override
  Handler? deregisterHandler(String name) =>
      _handlers.remove(name)?.handler as Handler?;

  @override
  void invoke() async {
    if (_invocations.isEmpty) {
      throw StateError('There are no queued invocations.'
          'Did you forget to call queueInvocation?');
    }

    final invocation = _invocations.removeFirst();
    final context = invocation.context;
    final func = _handlers[context.handler];
    if (func == null) {
      throw RuntimeException(
          'No handler with name "${context.handler}" registered in runtime!');
    }
    final json = invocation.eventJson;
    final callback = invocation.callback;
    final dynamic event =
        Event.fromHandler<AwsApiGatewayEvent>(func.type, json);
    final result = await func.handler(context, event) as AwsApiGatewayResponse;
    callback.complete(result);
  }
}