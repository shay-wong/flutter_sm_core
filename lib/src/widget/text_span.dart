import 'package:flutter/rendering.dart';

class MTextSpan extends TextSpan {
  MTextSpan({
    super.text,
    super.children,
    TextStyle? style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
    super.locale,
    super.spellOut,
    Color? color,
    double? fontSize,
    bool isBold = false,
    FontWeight? fontWeight,
    TextOverflow? overflow,
  }) : super(
          style: style ??
              _defaultStyle(
                color: color,
                fontSize: fontSize,
                isBold: isBold,
                fontWeight: fontWeight,
                overflow: overflow,
              ),
        );

  static TextStyle? _defaultStyle({
    Color? color,
    double? fontSize,
    bool isBold = false,
    FontWeight? fontWeight,
    TextOverflow? overflow,
  }) {
    if (color != null || fontSize != null || isBold || fontWeight != null) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight ?? (isBold ? FontWeight.bold : null),
        overflow: overflow,
      );
    }
    return null;
  }
}
