// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MError _$MErrorFromJson(Map<String, dynamic> json) => MError(
      code: json['code'] as num?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MErrorToJson(MError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
