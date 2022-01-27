// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      error: json['error'] as bool? ?? true,
      messages:
          (json['messages'] as List<dynamic>).map((e) => e as String).toList(),
      type: json['__type'] as String,
      context: json['context'] as Map<String, dynamic>?,
      stackTrace:
          (json['stackTrace'] as List<dynamic>?)?.map((e) => e as String),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
      '__type': instance.type,
      'stackTrace': instance.stackTrace?.toList(),
      'context': instance.context,
    };
