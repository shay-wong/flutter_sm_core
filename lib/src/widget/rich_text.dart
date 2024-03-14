// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

import 'text.dart';

class MRichText extends StatelessWidget {
  const MRichText({
    super.key,
    this.children,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.forceStrutHeight = false,
    this.isBold = false,
    this.locale,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.selectionColor,
    this.softWrap = true,
    this.strutStyle,
    this.style,
    this.text,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaler = TextScaler.noScaling,
    this.textWidthBasis = TextWidthBasis.parent,
  });

  final List<InlineSpan>? children;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final bool forceStrutHeight;
  final bool isBold;
  final Locale? locale;
  final int? maxLines;
  final TextOverflow overflow;
  final Color? selectionColor;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final InlineSpan? text;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final TextWidthBasis textWidthBasis;

  // NOTE: [TextScaler.noScaling] 导致 [Text] 和 [RichText] 设置相同 [fontSize] 显示大小不一致, [Text] 默认不是 [TextScaler.noScaling], 但是如果 [Text] 设置了 [TextScaler.noScaling], 还是会有细微的宽度差别, 宽高都会更大一点, 应该是有其他影响到了(猜测可能是有内边距?), 暂时没找到原因.
  final TextScaler textScaler;

  @override
  Widget build(BuildContext context) {
    return MText.rich(
      text: text,
      children: children,
      forceStrutHeight: forceStrutHeight,
      style: style,
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      selectionColor: selectionColor,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaler: textScaler,
      textWidthBasis: textWidthBasis,
      isBold: isBold,
    );
  }
}
