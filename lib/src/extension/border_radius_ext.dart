import 'package:flutter/material.dart';

extension MBorderRadius on BorderRadius {
  static BorderRadius circularVertical({
    double top = 0.0,
    double bottom = 0.0,
  }) =>
      BorderRadius.vertical(
        top: Radius.circular(top),
        bottom: Radius.circular(bottom),
      );

  static BorderRadius circularHorizontal({
    double left = 0.0,
    double right = 0.0,
  }) =>
      BorderRadius.horizontal(
        left: Radius.circular(left),
        right: Radius.circular(right),
      );
}
