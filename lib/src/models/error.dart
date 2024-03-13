import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../generated/locales.g.dart';

part 'error.g.dart';

enum MErrorCode {
  error(code: -11111, message: LocaleKeys.error),
  noNetwork(code: -99999, message: LocaleKeys.no_network);

  const MErrorCode({this.code, String? message}) : _message = message;

  final num? code;
  final String? _message;
}

extension MErrorCodeExt on MErrorCode {
  String? get message {
    return _message?.tr;
  }
}

@JsonSerializable()
class MError extends Error {
  MError({
    this.code,
    this.message,
  });

  MError.error({
    num? code,
    String? message,
  })  : code = code ?? MErrorCode.error.code,
        message = message ?? MErrorCode.error.message;

  factory MError.fromJson(Map<String, dynamic> json) => _$MErrorFromJson(json);

  MError.noNetwork({
    num? code,
    String? message,
  })  : code = code ?? MErrorCode.noNetwork.code,
        message = message ?? MErrorCode.noNetwork.message;

  final num? code;
  final String? message;

  @override
  String toString() => code != null && kDebugMode ? '$message\n$code' : '$message';

  Map<String, dynamic> toJson() => _$MErrorToJson(this);
}
