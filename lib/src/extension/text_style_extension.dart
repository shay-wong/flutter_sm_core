import 'package:flutter/painting.dart';

const String _kDefaultDebugLabel = 'unknown';

extension SMFontWeight on FontWeight {
  static const FontWeight thin = FontWeight.w300;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight exteraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

extension TextStyleEx on TextStyle {
  /// Returns a copy of this TextStyle where the non-null fields in [style]
  /// have replaced the corresponding null fields in this TextStyle.
  /// !!! _package fields is private, unable to replace package fields.
  ///
  /// In other words, [style] is used to fill in unspecified (null) fields
  /// this TextStyle.
  TextStyle mergeNonNull(TextStyle? other) {
    if (other == null) {
      return this;
    }
    if (!other.inherit) {
      return other;
    }

    String? mergedDebugLabel;
    assert(() {
      if (other.debugLabel != null || debugLabel != null) {
        mergedDebugLabel = '(${debugLabel ?? _kDefaultDebugLabel}).merge(${other.debugLabel ?? _kDefaultDebugLabel})';
      }
      return true;
    }());

    return copyWith(
      color: color ?? other.color,
      backgroundColor: backgroundColor ?? other.backgroundColor,
      fontSize: fontSize ?? other.fontSize,
      fontWeight: fontWeight ?? other.fontWeight,
      fontStyle: fontStyle ?? other.fontStyle,
      letterSpacing: letterSpacing ?? other.letterSpacing,
      wordSpacing: wordSpacing ?? other.wordSpacing,
      textBaseline: textBaseline ?? other.textBaseline,
      height: height ?? other.height,
      leadingDistribution: leadingDistribution ?? other.leadingDistribution,
      locale: locale ?? other.locale,
      foreground: foreground ?? other.foreground,
      background: background ?? other.background,
      shadows: shadows ?? other.shadows,
      fontFeatures: fontFeatures ?? other.fontFeatures,
      fontVariations: fontVariations ?? other.fontVariations,
      decoration: decoration ?? other.decoration,
      decorationColor: decorationColor ?? other.decorationColor,
      decorationStyle: decorationStyle ?? other.decorationStyle,
      decorationThickness: decorationThickness ?? other.decorationThickness,
      debugLabel: debugLabel ?? mergedDebugLabel,
      fontFamily: fontFamily ?? other.fontFamily,
      fontFamilyFallback: fontFamilyFallback ?? other.fontFamilyFallback,
      overflow: overflow ?? other.overflow,
    );
  }
}
