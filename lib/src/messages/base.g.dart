// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestBase _$RequestBaseFromJson(Map<String, dynamic> json) => RequestBase();

Map<String, dynamic> _$RequestBaseToJson(RequestBase instance) =>
    <String, dynamic>{};

ResponseBase _$ResponseBaseFromJson(Map<String, dynamic> json) => ResponseBase(
      error: json['error'] as bool? ?? false,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ResponseBaseToJson(ResponseBase instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messages': instance.messages,
    };
