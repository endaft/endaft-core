import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../messages/error.dart';

typedef MissingValueHandler<T> = T? Function(String key);

/// The base contract definition.
@immutable
abstract class AppContract extends Equatable {
  AppContract();

  @override
  List<Object?> get props => [];

  /// Stores operational context for this instance.
  ///
  /// This is ONLY available locally.
  /// This context is NOT transferred across the wire, and will not be included
  /// if this object is serialized.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> _context = <String, dynamic>{};

  /// Attaches a contextual value to this instance and returns the [value].
  /// The type of [T] is the signature/key, attaching more than one thing of
  /// the same will only store the last one.
  T attach<T>(T value) {
    final key = T.runtimeType.toString();
    _context[key] = value;
    return value;
  }

  /// Detaches a contextual value from this instance and returns it, or null if
  /// it didn't exist. The type of [T] is the signature/key of what will be
  /// removed if it exists. This won't throw if the value was NOT previously
  /// attached.
  T? detach<T>() {
    final key = T.runtimeType.toString();
    if (_context.containsKey(key)) {
      return _context.remove(key) as T?;
    }
    return null;
  }

  /// Gets a contextual value from this instance.
  /// The type of [T] is the signature/key of what will be returned if it exists.
  /// If the value doesn't exist, it invoke the [handler] for a return value,
  /// if one was provided, or throws a [BadContextError].
  ///
  /// Using a [handler] provides the option to throw a more specific exception,
  /// for example:
  /// ```dart
  /// obj.get<User>((key) => throw ArgumentError.notNull(key));
  /// ```
  ///
  /// Or, use it to provide a default value, for example:
  /// ```dart
  /// obj.get<Locale>((key) => Locale.fromName('en-US'));
  /// ```
  T get<T>([MissingValueHandler? handler]) {
    final key = T.runtimeType.toString();
    if (_context.containsKey(key)) {
      return _context[key] as T;
    }
    return handler != null
        ? handler(key) as T
        : throw BadContextError.missingKey(key);
  }

  /// Converts this instance to JSON.
  Map<String, dynamic> toJson();
}
