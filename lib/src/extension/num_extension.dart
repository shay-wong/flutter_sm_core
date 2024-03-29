import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/data_format/data_format.dart';
import 'string_extension.dart';

extension MDoubleExt on double {
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
  SizedBox get hSpace => SizedBox(width: this);
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get vSpace => SizedBox(height: this);

  double toPrecision(int fractionDigits) {
    var mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}

extension MIntExt on int {
  int? timeStampToHour() {
    //如果是十三位时间戳返回这个
    var timeStamp = this;
    if (toString().length == 13) {
      timeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp).hour;
    } else if (toString().length == 16) {
      //如果是十六位时间戳
      timeStamp = DateTime.fromMicrosecondsSinceEpoch(timeStamp).hour;
    }
    return timeStamp;
  }

  String toTimeStampString() {
    ///时间戳转日期
    DateTime dateTime = DateTime.now();

    ///如果是十三位时间戳返回这个
    if (toString().length == 13) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    } else if (toString().length == 16) {
      ///如果是十六位时间戳
      dateTime = DateTime.fromMicrosecondsSinceEpoch(this);
    }
    String dateTimeStr = dateTime.toString();

    ///去掉时间后面的:秒数.000
    return dateTimeStr.substring(0, dateTimeStr.length - 7);
  }

  String toTimeString([String? newPattern]) {
    newPattern ??= 'yyyy.mm.dd';
    if (this == 0) {
      return "";
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return MDateFormat(newPattern).format(dateTime);
  }
}

extension MNumExt on num {
  BorderRadius get circular => BorderRadius.circular(toDouble());
  BorderRadius get circularBottom =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));
  BorderRadius get circularLeft =>
      BorderRadius.horizontal(left: Radius.circular(toDouble()));
  BorderRadius get circularRight =>
      BorderRadius.horizontal(right: Radius.circular(toDouble()));
  BorderRadius get circularTop =>
      BorderRadius.vertical(top: Radius.circular(toDouble()));
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
  SizedBox get hSpace => SizedBox(width: toDouble());
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get vSpace => SizedBox(height: toDouble());

  /* 转换成金额格式
  * fix: 保留多少位小数点，默认 2 位
  * remove: 是否移除无意义的 0
  */
  String toMoney({
    int fix = 2,
    bool remove = true,
  }) {
    var money = toStringAsFixed(fix);
    if (remove) {
      money = money.remove0Tail;
    }
    return money;
  }

  double toPrecision(int fractionDigits) =>
      toDouble().toPrecision(fractionDigits);
}
