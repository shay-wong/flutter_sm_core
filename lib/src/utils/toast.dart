import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../extension/duration_extension.dart';

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
  /// init EasyLoading
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return EasyLoading.init();
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..fontSize = 15
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..dismissOnTap = false
      ..customAnimation = CustomAnimation();
  }

  static dismiss({
    bool animation = true,
  }) {
    EasyLoading.dismiss(animation: animation);
  }

  static show({
    String? msg,
    Widget? indicator,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.none,
    bool? dismissOnTap,
  }) {
    EasyLoading.show(
      status: msg,
      indicator: indicator ??
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 50,
          ),
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
