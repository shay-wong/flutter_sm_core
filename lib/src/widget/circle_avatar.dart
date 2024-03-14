import 'package:flutter/material.dart';

import 'sm_image/src/image.dart';

class MCircleAvatar extends StatelessWidget {
  const MCircleAvatar(
    this.url, {
    super.key,
    this.placeholder,
    double? width,
    double? height,
    double? size,
    this.onTap,
  })  : width = width ?? size,
        height = height ?? size;

  final String? placeholder;
  final String? url;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSizeBox = width != null && height != null;
    final isGesture = onTap != null;
    Widget child = _circleAvatar;

    if (isSizeBox) {
      child = SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }
    if (isGesture) {
      child = InkWell(
        onTap: onTap,
        child: child,
      );
    }
    // TODO: 显示错误图片
    return child;
  }

  CircleAvatar get _circleAvatar => CircleAvatar(
        backgroundImage: MImage.provider(
          url,
          placeholder: placeholder ?? 'assets/images/icons/avatar.png',
        ),
      );
}
