import 'dart:io' if (dart.library.html) 'dart:html' show HttpStatus;

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../contracts/all.dart';
export '../contracts/all.dart';

part 'base.g.dart';

@immutable
@JsonSerializable()
class RequestBase extends AppContract {
  RequestBase();

  @override
  List<Object?> get props => [];

  factory RequestBase.fromJson(Map<String, dynamic> json) =>
      _$RequestBaseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestBaseToJson(this);
}

@immutable
@JsonSerializable()
class ResponseBase extends AppContract {
  ResponseBase({
    this.error = false,
    this.messages = const [],
    this.statusCode = HttpStatus.ok,
  });

  final bool error;
  final List<String> messages;

  @JsonKey(ignore: true)
  final int statusCode;

  @override
  List<Object?> get props => [error, messages];

  factory ResponseBase.fromJson(Map<String, dynamic> json) =>
      _$ResponseBaseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ResponseBaseToJson(this);
}
