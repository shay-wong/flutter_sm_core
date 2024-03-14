import 'package:flutter/material.dart';

import 'app_bar.dart';

class MScaffold extends Scaffold {
  MScaffold({
    super.key,
    super.body,
    PreferredSizeWidget? appBar,
    String? title,
    Color? titleColor,
    Widget? leading,
    bool isRoot = false,
    super.backgroundColor,
    List<Widget>? actions,
    VoidCallback? onBack,
    String? previousRoute,
    Color? barBackgourndColor,
    Color? barForegroundColor,
    bool? centerTitle,
  }) : super(
          appBar: appBar ??
              (title != null || actions != null
                  ? MAppBar(
                      titleText: title,
                      leading: leading,
                      isRoot: isRoot,
                      actions: actions,
                      onBack: onBack,
                      backgroundColor: barBackgourndColor,
                      foregroundColor: barForegroundColor,
                      previousRoute: previousRoute,
                      centerTitle: centerTitle ?? true,
                    )
                  : null),
        );
}
