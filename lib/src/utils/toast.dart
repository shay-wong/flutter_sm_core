// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../extension/duration_extension.dart';

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class MToast {
  static dismiss({
    bool animation = true,
  }) {
    EasyLoading.dismiss(animation: animation);
  }

  /// init EasyLoading
  static TransitionBuilder init({
    TransitionBuilder? builder,
    MToastConfig? config,
  }) {
    config ?? MToastConfig();
    return EasyLoading.init(builder: builder);
  }

  static show({
    String? msg,
    Widget? indicator,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    EasyLoading.show(
      status: msg,
      indicator: indicator,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  static Future<void> showError(
    String? msg, {
    Duration? duration,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    return EasyLoading.showError(
      msg ?? 'Error',
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  static Future<void> showInfo(
    String? msg, {
    Duration? duration,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    return EasyLoading.showInfo(
      msg ?? '',
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  static Future<void> showSuccess(
    String? msg, {
    Duration? duration,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    return EasyLoading.showSuccess(
      msg ?? 'Success',
      duration: duration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  static Future<void> showToast(
    String? msg, {
    Duration? duration,
    MToastPosition? position,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    return EasyLoading.showToast(
      msg ?? '',
      duration: duration ?? 1.5.seconds,
      toastPosition: position?.position,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }
}

class MToastConfig {
  MToastConfig({
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationStyle = EasyLoadingAnimationStyle.opacity,
    this.backgroundColor = Colors.green,
    this.boxShadow,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
    this.customAnimation,
    this.dismissOnTap = false,
    this.displayDuration = const Duration(milliseconds: 2000),
    this.errorWidget,
    this.fontSize = 15.0,
    this.indicatorColor = Colors.yellow,
    this.indicatorSize = 45.0,
    this.indicatorType = EasyLoadingIndicatorType.fadingCircle,
    this.indicatorWidget,
    this.lineWidth = 4.0,
    this.loadingStyle = EasyLoadingStyle.dark,
    this.maskColor = const Color(0x802196F3),
    this.maskType = EasyLoadingMaskType.none,
    this.progressColor = Colors.yellow,
    this.progressWidth = 2.0,
    this.radius = 10.0,
    this.successWidget,
    this.textAlign = TextAlign.center,
    this.textColor = Colors.yellow,
    this.textPadding = const EdgeInsets.only(bottom: 10.0),
    this.textStyle,
    this.toastPosition = EasyLoadingToastPosition.center,
    this.userInteractions,
  }) {
    EasyLoading.instance
      ..animationDuration = animationDuration
      ..animationStyle = animationStyle
      ..backgroundColor = backgroundColor
      ..boxShadow = boxShadow
      ..contentPadding = contentPadding
      ..displayDuration = displayDuration
      ..indicatorType = indicatorType
      ..loadingStyle = loadingStyle
      ..indicatorSize = indicatorSize
      ..fontSize = fontSize
      ..radius = radius
      ..progressColor = progressColor
      ..progressWidth = progressWidth
      ..indicatorColor = indicatorColor
      ..textColor = textColor
      ..maskColor = maskColor
      ..maskType = maskType
      ..dismissOnTap = dismissOnTap
      ..indicatorWidget = indicatorWidget
      ..errorWidget = errorWidget
      ..lineWidth = lineWidth
      ..successWidget = successWidget
      ..textAlign = textAlign
      ..textPadding = textPadding
      ..textStyle = textStyle
      ..toastPosition = toastPosition
      ..userInteractions = userInteractions
      ..customAnimation = customAnimation ?? CustomAnimation();
  }

  /// animation duration of indicator, default 200ms.
  Duration animationDuration;

  /// loading animationStyle, default [EasyLoadingAnimationStyle.opacity].
  EasyLoadingAnimationStyle animationStyle;

  /// background color of loading, only used for [EasyLoadingStyle.custom].
  Color backgroundColor;

  /// boxShadow of loading, only used for [EasyLoadingStyle.custom].
  List<BoxShadow>? boxShadow;

  /// content padding of loading.
  EdgeInsets contentPadding;

  /// loading custom animation, default null.
  EasyLoadingAnimation? customAnimation;

  /// should dismiss on user tap.
  bool dismissOnTap;

  /// display duration of [showSuccess] [showError] [showInfo] [showToast], default 2000ms.
  Duration displayDuration;

  /// error widget of loading
  Widget? errorWidget;

  /// fontSize of loading, default 15.0.
  double fontSize;

  /// color of loading indicator, only used for [EasyLoadingStyle.custom].
  Color indicatorColor;

  /// size of indicator, default 40.0.
  double indicatorSize;

  /// loading indicator type, default [EasyLoadingIndicatorType.fadingCircle].
  EasyLoadingIndicatorType indicatorType;

  /// indicator widget of loading
  Widget? indicatorWidget;

  /// width of indicator, default 4.0, only used for [EasyLoadingIndicatorType.ring, EasyLoadingIndicatorType.dualRing].
  double lineWidth;

  /// loading style, default [EasyLoadingStyle.dark].
  EasyLoadingStyle loadingStyle;

  /// mask color of loading, only used for [EasyLoadingMaskType.custom].
  Color maskColor;

  /// loading mask type, default [EasyLoadingMaskType.none].
  EasyLoadingMaskType maskType;

  /// progress color of loading, only used for [EasyLoadingStyle.custom].
  Color progressColor;

  /// width of progress indicator, default 2.0.
  double progressWidth;

  /// radius of loading, default 5.0.
  double radius;

  /// success widget of loading
  Widget? successWidget;

  /// textAlign of status, default [TextAlign.center].
  TextAlign textAlign;

  /// color of loading status, only used for [EasyLoadingStyle.custom].
  Color textColor;

  /// padding of [status].
  EdgeInsets textPadding;

  /// textStyle of status, default null.
  TextStyle? textStyle;

  /// toast position, default [EasyLoadingToastPosition.center].
  EasyLoadingToastPosition toastPosition;

  /// should allow user interactions while loading is displayed.
  bool? userInteractions;

  MToastConfig copyWith({
    Duration? animationDuration,
    EasyLoadingAnimationStyle? animationStyle,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    EdgeInsets? contentPadding,
    EasyLoadingAnimation? customAnimation,
    bool? dismissOnTap,
    Duration? displayDuration,
    Widget? errorWidget,
    double? fontSize,
    Color? indicatorColor,
    double? indicatorSize,
    EasyLoadingIndicatorType? indicatorType,
    Widget? indicatorWidget,
    double? lineWidth,
    EasyLoadingStyle? loadingStyle,
    Color? maskColor,
    EasyLoadingMaskType? maskType,
    Color? progressColor,
    double? progressWidth,
    double? radius,
    Widget? successWidget,
    TextAlign? textAlign,
    Color? textColor,
    EdgeInsets? textPadding,
    TextStyle? textStyle,
    EasyLoadingToastPosition? toastPosition,
    bool? userInteractions,
  }) {
    return MToastConfig(
      animationDuration: animationDuration ?? this.animationDuration,
      animationStyle: animationStyle ?? this.animationStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
      contentPadding: contentPadding ?? this.contentPadding,
      customAnimation: customAnimation ?? this.customAnimation,
      dismissOnTap: dismissOnTap ?? this.dismissOnTap,
      displayDuration: displayDuration ?? this.displayDuration,
      errorWidget: errorWidget ?? this.errorWidget,
      fontSize: fontSize ?? this.fontSize,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      indicatorType: indicatorType ?? this.indicatorType,
      indicatorWidget: indicatorWidget ?? this.indicatorWidget,
      lineWidth: lineWidth ?? this.lineWidth,
      loadingStyle: loadingStyle ?? this.loadingStyle,
      maskColor: maskColor ?? this.maskColor,
      maskType: maskType ?? this.maskType,
      progressColor: progressColor ?? this.progressColor,
      progressWidth: progressWidth ?? this.progressWidth,
      radius: radius ?? this.radius,
      successWidget: successWidget ?? this.successWidget,
      textAlign: textAlign ?? this.textAlign,
      textColor: textColor ?? this.textColor,
      textPadding: textPadding ?? this.textPadding,
      textStyle: textStyle ?? this.textStyle,
      toastPosition: toastPosition ?? this.toastPosition,
      userInteractions: userInteractions ?? this.userInteractions,
    );
  }
}

enum MToastPosition {
  top,
  center,
  bottom,
}

extension MToastPositionEx on MToastPosition {
  EasyLoadingToastPosition? get position {
    switch (this) {
      case MToastPosition.top:
        return EasyLoadingToastPosition.top;
      case MToastPosition.center:
        return EasyLoadingToastPosition.center;
      case MToastPosition.bottom:
        return EasyLoadingToastPosition.bottom;
      default:
        return null;
    }
  }
}
