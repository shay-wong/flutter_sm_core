import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

enum MBoxShape {
  rectangle,
  circle,
  stadium,
}

class MContainer extends StatelessWidget {
  /// Container 组件, 可以设置宽高，边框，圆角等属性
  /// [MContainer]
  /// [width] 宽度
  /// [height] 高度
  /// [child] 子组件
  /// [alignment] 对齐方式
  /// [border] 边框
  /// [borderRadius] 圆角
  /// [clipBehavior] 裁剪
  /// [color] 背景色
  /// [decoration] 装饰
  /// [fit] 图片填充模式
  /// [foregroundDecoration] 前景装饰
  /// [gradient] 渐变
  /// [image] 图片
  /// [imageAlignment] 图片对齐方式
  /// [imageSource] 图片来源
  /// [margin] 外边距
  /// [padding] 内边距
  /// [radius] 圆角
  /// [repeat] 图片重复模式
  /// [scale] 图片缩放
  /// [shadows] 阴影
  /// [side] 边框
  /// [transform] 旋转
  /// [transformAlignment] 旋转对齐方式
  /// [centerSlice] 图片切片
  /// [maxHeight] 最大高度
  /// [maxWidth] 最大宽度
  /// [minHeight] 最小高度
  /// [minWidth] 最小宽度
  /// [shape] 形状
  /// [constraints] 约束
  MContainer({
    super.key,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.alignment,
    this.border,
    this.borderRadius,
    this.child,
    this.clipBehavior = Clip.none,
    this.color,
    this.decoration,
    this.fit,
    this.foregroundDecoration,
    this.gradient,
    this.image,
    this.imageAlignment,
    this.imageSource,
    this.margin,
    this.padding,
    this.radius,
    this.repeat = ImageRepeat.noRepeat,
    this.scale = 1.0,
    this.shadows,
    this.side,
    this.transform,
    this.transformAlignment,
    this.centerSlice,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.shape,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(decoration != null || clipBehavior == Clip.none),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  final AlignmentGeometry? alignment;
  final BoxBorder? border;
  final Widget? child;
  final Clip clipBehavior;
  final BoxConstraints? constraints;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final ImageProvider? image;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;

  /// 圆角, 适用于 [MBoxShape.rectangle]
  final BorderRadius? borderRadius;

  /// 九片图像的中心切片, 设置切片拉伸区域, Rect 是根据图片的原始大小来定位中心切片区域。
  /// 中心切片内的图像区域将被水平和垂直拉伸，以使图像适合其目标。
  /// 中心切片上方和下方的图像区域将仅被水平拉伸，中心切片左侧和右侧的图像区域将仅被垂直拉伸。
  ///
  /// 将应用拉伸以使图像适合 [fit] 指定的框。
  /// 当 [centerSlice] 不为null时，[fit] 默认为 [BoxFit.fill]，这会使目标图像的大小相对于图像的原始宽高比失真。
  /// 不扭曲目标图像大小的 [BoxFit] 的值将导致 [centerSlice] 没有效果 (因为图像的九个区域将以相同的缩放比例呈现，就像未指定一样)。
  final Rect? centerSlice;

  /// 颜色可以和 [decoration] 一起使用, 如果有 [decoration], 则会覆盖 [color]
  final Color? color;

  /// [image] 填充模式
  final BoxFit? fit;

  /// 背景渐变
  final Gradient? gradient;

  /// [image] 的对齐方式
  final AlignmentGeometry? imageAlignment;

  /// [image] 来源
  final String? imageSource;

  /// 设置宽高最大值, 不设置为无穷大, 当设置 [width] 或 [height] 或 [constraints] 时无效
  final double? maxHeight;

  /// 设置宽高最小值, 不设置为无穷大, 当设置 [width] 或 [height] 或 [constraints] 时无效
  final double? maxWidth;

  /// 设置宽高最小值, 不设置为 0
  final double? minHeight;

  /// 设置宽高最小值, 不设置为 0
  final double? minWidth;

  /// 圆角
  final double? radius;

  /// [image] 重复模式
  final ImageRepeat repeat;

  /// [image] 拉伸因子
  final double scale;

  /// 阴影
  final List<BoxShadow>? shadows;

  /// [MBoxShape]
  final MBoxShape? shape;

  /// 边框
  final BorderSide? side;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment, showName: false, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior, defaultValue: Clip.none));
    if (color != null) {
      properties.add(DiagnosticsProperty<Color>('bg', color));
    } else {
      properties.add(DiagnosticsProperty<Decoration>('bg', decoration, defaultValue: null));
    }
    properties.add(DiagnosticsProperty<Decoration>('fg', foregroundDecoration, defaultValue: null));
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin, defaultValue: null));
    properties.add(ObjectFlagProperty<Matrix4>.has('transform', transform));
  }

  Decoration? get _generateDecoration {
    if (decoration != null) {
      return decoration;
    }
    if (image != null ||
        imageSource != null ||
        border != null ||
        borderRadius != null ||
        radius != null ||
        side != null ||
        shape != null ||
        gradient != null ||
        shadows != null) {
      var image = this.image;
      final imageSource = this.imageSource;

      if (image == null && imageSource != null && imageSource.isNotEmpty) {
        final uri = Uri.tryParse(imageSource);
        if (uri != null && uri.hasScheme) {
          image = NetworkImage(imageSource);
        } else {
          image = AssetImage(imageSource);
        }
      }

      DecorationImage? decorationImage;
      if (image != null) {
        decorationImage = DecorationImage(
          image: image,
          fit: fit,
          scale: scale,
          repeat: repeat,
          centerSlice: centerSlice,
          alignment: imageAlignment ?? Alignment.center,
        );
      }

      if (side != null || shape == MBoxShape.stadium) {
        return ShapeDecoration(
          color: color,
          image: decorationImage,
          gradient: gradient,
          shadows: shadows,
          shape: StadiumBorder(
            side: side ?? BorderSide.none,
          ),
        );
      } else {
        BoxShape finalShape = shape == MBoxShape.circle ? BoxShape.circle : BoxShape.rectangle;

        BorderRadius? finalBorderRadius;
        // 如果你是一个圆形，就不能有 borderRadius。 所以只在矩形下设置 borderRadius
        if (finalShape == BoxShape.rectangle) {
          finalBorderRadius = borderRadius;
          if (finalBorderRadius == null && radius != null) {
            finalBorderRadius = BorderRadius.circular(radius!);
          }
        }

        return BoxDecoration(
          color: color,
          image: decorationImage,
          border: border,
          borderRadius: finalBorderRadius,
          shape: finalShape,
          boxShadow: shadows,
          gradient: gradient,
        );
      }
    }
    return null;
  }

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    if (decoration == null) {
      return padding;
    }
    final EdgeInsetsGeometry decorationPadding = decoration!.padding;
    if (padding == null) {
      return decorationPadding;
    }
    return padding!.add(decorationPadding);
  }

  @override
  Widget build(BuildContext context) {
    Widget? current = child;

    if (child == null && (constraints == null || !constraints!.isTight)) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    } else if (alignment != null) {
      current = Align(alignment: alignment!, child: current);
    }

    final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      current = Padding(padding: effectivePadding, child: current);
    }

    if (clipBehavior != Clip.none) {
      assert(decoration != null);
      current = ClipPath(
        clipper: _SMDecorationClipper(
          textDirection: Directionality.maybeOf(context),
          decoration: decoration!,
        ),
        clipBehavior: clipBehavior,
        child: current,
      );
    }

    final Decoration? generateDecoration = _generateDecoration;
    if (generateDecoration != null) {
      current = DecoratedBox(decoration: generateDecoration, child: current);
    } else if (color != null) {
      current = ColoredBox(color: color!, child: current);
    }

    if (foregroundDecoration != null) {
      current = DecoratedBox(
        decoration: foregroundDecoration!,
        position: DecorationPosition.foreground,
        child: current,
      );
    }

    if (constraints != null) {
      current = ConstrainedBox(constraints: constraints!, child: current);
    } else if (maxWidth != null || maxHeight != null || minWidth != null || minHeight != null) {
      current = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0.0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0.0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: current,
      );
    }

    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }

    if (transform != null) {
      current = Transform(transform: transform!, alignment: transformAlignment, child: current);
    }

    return current!;
  }
}

/// A clipper that uses [Decoration.getClipPath] to clip.
class _SMDecorationClipper extends CustomClipper<Path> {
  _SMDecorationClipper({
    TextDirection? textDirection,
    required this.decoration,
  }) : textDirection = textDirection ?? TextDirection.ltr;

  final Decoration decoration;
  final TextDirection textDirection;

  @override
  Path getClip(Size size) {
    return decoration.getClipPath(Offset.zero & size, textDirection);
  }

  @override
  bool shouldReclip(_SMDecorationClipper oldClipper) {
    return oldClipper.decoration != decoration || oldClipper.textDirection != textDirection;
  }
}
