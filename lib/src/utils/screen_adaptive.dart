import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const designSize = Size(375, 667);
const double maximumScale = 2.0;
const double maximumScale1 = 1.5;
const double maximumFontScale = maximumScale1;
ScreenUtil get screenUtil => ScreenUtil();
double get screenWidth => screenUtil.screenWidth;
double get screenHeight => screenUtil.screenHeight;
double get designWidth => designSize.width;
double get designHeight => designSize.height;
double get scaleWidth => screenUtil.scaleWidth;
double get scaleHeight => screenUtil.scaleHeight;
double get aScaleWidth => screenUtil.limitScaleWidth;
double get aScaleHeight => screenUtil.limitScaleHeight;
double get imageScaleWidth => 1 / screenUtil.limitScaleWidth;
double get imageScaleHeight => 1 / screenUtil.limitScaleHeight;
Size get screenSize => Size(screenWidth, screenHeight);
double get safeHeight => screenUtil.statusBarHeight + screenUtil.bottomBarHeight;
double get safeTop => screenUtil.statusBarHeight;
double get safeBottom => screenUtil.bottomBarHeight;
double get pixelRatio => Get.pixelRatio;
double get scale => min(pixelRatio, maximumScale);
double get bottomNavigationBarHeight => 56;

const double chatMaximumWidth = 250;

extension ScreenUtilExt on ScreenUtil {
  double get limitScaleWidth => min(screenUtil.scaleWidth, maximumScale);
  double get limitScaleHeight => min(screenUtil.scaleHeight, maximumScale);
  double get limitScaleText => min(screenUtil.scaleText, maximumFontScale);
}

extension NumExt on num {
  double maximum(num maximum) => min(toDouble(), maximum.toDouble());
  double minimum(num minimum) => max(toDouble(), minimum.toDouble());
  double aws(num scale) => this * min(scale.toDouble(), screenUtil.limitScaleWidth);
  double ahs(num scale) => this * min(scale.toDouble(), screenUtil.limitScaleHeight);
  double get aw => this * screenUtil.limitScaleWidth;
  double get ah => this * screenUtil.limitScaleHeight;
  double get asp => min(sp, this * screenUtil.limitScaleText);
  int get imgCache => (this * pixelRatio).round();
}

extension DoubleExt on double {
  double maximum(num maximum) => min(toDouble(), maximum.toDouble());
  double minimum(num minimum) => max(toDouble(), minimum.toDouble());
  double aws(num scale) => this * min(scale.toDouble(), screenUtil.limitScaleWidth);
  double ahs(num scale) => this * min(scale.toDouble(), screenUtil.limitScaleHeight);
  double get aw => this * screenUtil.limitScaleWidth;
  double get ah => this * screenUtil.limitScaleHeight;
  double get asp => min(sp, this * screenUtil.limitScaleText);
  int get imgCache => (this * pixelRatio).round();
}

extension EdgeInsetsExt on EdgeInsets {
  /// Creates adapt EdgeInsets using r [NumExt].
  EdgeInsets get aw => copyWith(
        left: left.aw,
        top: top.aw,
        right: right.aw,
        bottom: bottom.aw,
      );
  EdgeInsets get wh => copyWith(
        left: left.w,
        top: top.h,
        right: right.w,
        bottom: bottom.h,
      );
  EdgeInsets get awh => copyWith(
        left: left.aw,
        top: top.ah,
        right: right.aw,
        bottom: bottom.ah,
      );
  EdgeInsets maximumAll(double value) => copyWith(
        left: left.maximum(left),
        top: top.maximum(top),
        right: right.maximum(right),
        bottom: bottom.maximum(bottom),
      );
  EdgeInsets maximumOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      copyWith(
        left: this.left.maximum(left ?? double.infinity),
        top: this.top.maximum(top ?? double.infinity),
        right: this.right.maximum(right ?? double.infinity),
        bottom: this.bottom.maximum(bottom ?? double.infinity),
      );

  EdgeInsets aws(num scale) => copyWith(
        left: left.aws(scale),
        top: top.aws(scale),
        right: right.aws(scale),
        bottom: bottom.aws(scale),
      );

  EdgeInsets ahs(num scale) => copyWith(
        left: left.ahs(scale),
        top: top.ahs(scale),
        right: right.ahs(scale),
        bottom: bottom.ahs(scale),
      );
}

extension BorderRadiusExt on BorderRadius {
  /// Creates adapt BorderRadius using r [NumExt].
  BorderRadius get aw => copyWith(
        topLeft: topLeft.aw,
        topRight: topRight.aw,
        bottomLeft: bottomLeft.aw,
        bottomRight: bottomRight.aw,
      );
  BorderRadius get ah => copyWith(
        topLeft: topLeft.ah,
        topRight: topRight.ah,
        bottomLeft: bottomLeft.ah,
        bottomRight: bottomRight.ah,
      );
  BorderRadius aws(num scale) => copyWith(
        topLeft: topLeft.aws(scale),
        topRight: topRight.aws(scale),
        bottomLeft: bottomLeft.aws(scale),
        bottomRight: bottomRight.aws(scale),
      );

  BorderRadius ahs(num scale) => copyWith(
        topLeft: topLeft.ahs(scale),
        topRight: topRight.ahs(scale),
        bottomLeft: bottomLeft.ahs(scale),
        bottomRight: bottomRight.ahs(scale),
      );
}

extension RaduisExt on Radius {
  /// Creates adapt Radius using r [NumExt].
  Radius get aw => Radius.elliptical(x.aw, y.aw);
  Radius get ah => Radius.elliptical(x.ah, y.ah);
  Radius aws(num scale) => Radius.elliptical(x.aws(scale), y.aws(scale));
  Radius ahs(num scale) => Radius.elliptical(x.ahs(scale), y.ahs(scale));
}

extension SizeExt on Size {
  /// Creates adapt Size using r [NumExt].
  Size get aw => Size(width.aw, height.aw);
  Size get ah => Size(width.ah, height.ah);
}

extension SizedBoxExt on SizedBox {
  /// Creates adapt SizedBox using r [NumExt].
  SizedBox get aw => SizedBox(
        key: key,
        width: width?.aw,
        height: height?.aw,
        child: child,
      );
  SizedBox aws(num scale) => SizedBox(
        key: key,
        width: width?.aws(scale),
        height: height?.aws(scale),
        child: child,
      );
}
