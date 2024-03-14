import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/screen_adaptive.dart';
import 'text.dart';

class MAppBar extends AppBar {
  MAppBar({
    super.key,
    Widget? title,
    String? titleText,
    Widget? leading,
    Color? color,
    double? fontSize,
    super.bottom,
    super.actions,
    super.centerTitle,
    super.backgroundColor,
    super.foregroundColor,
    super.elevation,
    super.toolbarHeight,
    VoidCallback? onBack,
    String? previousRoute,
    super.flexibleSpace,
    bool isRoot = false,
    String? rootName,
    super.surfaceTintColor,
    super.shadowColor,
    IconData? backIconData,
    double? backIconSize,
  }) : super(
          title: titleText == null
              ? title
              : MText(
                  titleText,
                  style: Get.theme.appBarTheme.titleTextStyle?.copyWith(
                    fontSize: fontSize,
                    color: color ?? foregroundColor,
                  ),
                ),
          leading: leading ??
              (isRoot
                  ? null
                  : IconButton(
                      onPressed: onBack ??
                          () {
                            if (Get.rootController.rootDelegate.canBack) {
                              Get.back();
                            } else if (previousRoute != null) {
                              Get.offNamed(previousRoute);
                            } else if (Get.currentRoute == Get.previousRoute &&
                                rootName != null &&
                                Get.currentRoute != rootName) {
                              Get.offNamed(rootName);
                            } else {
                              Get.offNamed(Get.previousRoute);
                            }
                          },
                      icon: Icon(
                        backIconData ?? Icons.arrow_back_ios_new_rounded,
                        size: backIconSize ?? 18.aw.maximum(25),
                        color: foregroundColor,
                      ),
                    )),
        );
}
