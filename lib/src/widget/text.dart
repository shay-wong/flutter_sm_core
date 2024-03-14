// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MText extends StatelessWidget {
  const MText(
    this.data, {
    super.key,
    this.color,
    this.decoration,
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.forceStrutHeight = false,
    this.foreground,
    this.isBold = false,
    this.isDeleted = false,
    this.isItalic = false,
    this.lineHeight,
    this.locale,
    this.maxLines,
    this.overflow,
    this.selectionColor,
    this.semanticsLabel,
    this.shadows,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaler,
    this.textWidthBasis,
  })  : textSpan = null,
        children = null;

  const MText.rich({
    super.key,
    InlineSpan? text,
    this.children,
    this.color,
    this.decoration,
    this.fontFamily,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.forceStrutHeight = false,
    this.foreground,
    this.isBold = false,
    this.isDeleted = false,
    this.isItalic = false,
    this.lineHeight,
    this.locale,
    this.maxLines,
    this.overflow,
    this.selectionColor,
    this.semanticsLabel,
    this.shadows,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaler,
    this.textWidthBasis,
  })  : data = null,
        textSpan = text,
        assert(text == null || children == null);

  final List<InlineSpan>? children;
  final Color? color;
  final String? data;
  final TextDecoration? decoration;
  final String? fontFamily;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final bool forceStrutHeight;
  final Paint? foreground;
  final bool isBold;
  final bool isDeleted;
  final bool isItalic;
  final double? lineHeight;
  final Locale? locale;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? selectionColor;
  final String? semanticsLabel;
  final List<Shadow>? shadows;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final ui.TextHeightBehavior? textHeightBehavior;
  final TextScaler? textScaler;
  final InlineSpan? textSpan;
  final TextWidthBasis? textWidthBasis;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', data, showName: false));
    if (textSpan != null) {
      properties.add(textSpan!.toDiagnosticsNode(name: 'textSpan', style: DiagnosticsTreeStyle.transition));
    }
    style?.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign, defaultValue: null));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(DiagnosticsProperty<Locale>('locale', locale, defaultValue: null));
    properties.add(FlagProperty('softWrap',
        value: softWrap,
        ifTrue: 'wrapping at box width',
        ifFalse: 'no wrapping except at line break characters',
        showName: true));
    properties.add(EnumProperty<TextOverflow>('overflow', overflow, defaultValue: null));
    properties.add(IntProperty('maxLines', maxLines, defaultValue: null));
    properties.add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis, defaultValue: null));
    properties
        .add(DiagnosticsProperty<ui.TextHeightBehavior>('textHeightBehavior', textHeightBehavior, defaultValue: null));
    if (semanticsLabel != null) {
      properties.add(StringProperty('semanticsLabel', semanticsLabel));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    if (style == null) {
      effectiveTextStyle = effectiveTextStyle?.copyWith(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight ?? (isBold ? FontWeight.bold : null),
        fontStyle: fontStyle ?? (isItalic ? FontStyle.italic : null),
        decoration: decoration ??
            (isDeleted
                ? TextDecoration.lineThrough
                : TextDecoration.none), // 默认 TextDecoration.none 是为了去除没有Scaffold 或者 material 时的文本下黄线
        foreground: foreground,
        shadows: shadows,
      );
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);
    final TextScaler textScaler = this.textScaler ?? MediaQuery.textScalerOf(context);

    StrutStyle? effectiveStrutStyle = strutStyle;
    if (strutStyle == null && forceStrutHeight || lineHeight != null) {
      effectiveStrutStyle = StrutStyle.fromTextStyle(
        effectiveTextStyle!,
        height: lineHeight,
        forceStrutHeight: true,
      );
    }

    // OPTIMIZE: Flutter 不允许修改省略号的位置, 有时间自己处理
    // 当 [overflow] 为空 [maxLines] 不为空时, 默认使用 [TextOverflow.ellipsis]
    final finalOverflow = overflow ??
        (maxLines != null ? TextOverflow.ellipsis : null) ??
        effectiveTextStyle?.overflow ??
        defaultTextStyle.overflow;

    Widget result = RichText(
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: textDirection, // RichText uses Directionality.of to obtain a default if this is null.
      locale: locale, // RichText uses Localizations.localeOf to obtain a default if this is null
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow: finalOverflow,
      textScaler: textScaler,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      strutStyle: effectiveStrutStyle,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior:
          textHeightBehavior ?? defaultTextStyle.textHeightBehavior ?? DefaultTextHeightBehavior.maybeOf(context),
      selectionRegistrar: registrar,
      selectionColor:
          selectionColor ?? DefaultSelectionStyle.of(context).selectionColor ?? DefaultSelectionStyle.defaultColor,
      text: TextSpan(
        style: effectiveTextStyle,
        text: data,
        children: textSpan != null ? <InlineSpan>[textSpan!] : children,
      ),
    );
    if (registrar != null) {
      result = MouseRegion(
        cursor: DefaultSelectionStyle.of(context).mouseCursor ?? SystemMouseCursors.text,
        child: result,
      );
    }
    if (semanticsLabel != null) {
      result = Semantics(
        textDirection: textDirection,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }
}

extension MTextToSpanExt on MText {
  TextSpan toTextSpan() {
    return TextSpan(
      text: data,
      style: style ??
          TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? const Color(0xFF333333),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
      children: textSpan != null ? <InlineSpan>[textSpan!] : null,
    );
  }
}
