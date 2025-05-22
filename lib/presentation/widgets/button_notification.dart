import 'package:flutter/material.dart';
import 'package:minichat/data/values/app_colors.dart';

class ButtonNotification extends StatelessWidget {
  final Function()? onPress;
  final String? text;
  final bool expand;
  final bool negativeColor;
  final IconData? icon;
  final double elevation;
  final double radius;
  final double? border;
  final Color? borderColor;
  final Color? color;
  final Color? backgroundColor;
  final Color disabledBackgroundColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final bool useBorder;
  final bool reverse;
  final Widget? iconWidget;
  final Widget? imageLeft;
  final Widget? imageRight;
  final double opacity;
  final double textSize;
  final TextStyle? textStyle;

  const ButtonNotification(this.text,
      {super.key,
      this.icon,
      this.iconWidget,
      this.onPress,
      this.reverse = false,
      this.expand = false,
      this.negativeColor = false,
      this.elevation = 4,
      this.radius = 4,
      this.border,
      this.borderColor,
      this.color,
      this.backgroundColor,
      this.disabledBackgroundColor = AppColor.grey,
      this.textColor,
      this.disabledTextColor,
      this.useBorder = true,
      this.imageLeft,
      this.imageRight,
      this.opacity = 1,
      this.textSize = 16,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    var backgroundColor = AppColor.kBlueLight;
    var textColor = AppColor.white;

    if (negativeColor) {
      backgroundColor = AppColor.white;
      textColor = AppColor.kBlueLight;
    }
    if (this.backgroundColor != null) {
      backgroundColor = this.backgroundColor!;
    }
    if (this.textColor != null) {
      textColor = this.textColor!;
    }

    return SizedBox(
      width: expand ? double.maxFinite : null,
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: backgroundColor,
        onPressed: onPress,
        elevation: elevation,
        disabledColor: disabledBackgroundColor,
        textColor: textColor,
        disabledTextColor: disabledTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: border != null && useBorder
              ? BorderSide(
                  width: border!,
                  color: borderColor ?? textColor,
                )
              : BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: () {
            var x = <Widget>[
              if (imageLeft != null) ...[
                imageLeft!,
                const SizedBox(
                  width: 4,
                ),
              ],
              if (iconWidget != null || icon != null) ...[
                if (iconWidget != null) ...[iconWidget!],
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor,
                    size: 18,
                  ),
                ],
                const SizedBox(
                  width: 8,
                ),
              ],
              if (text != null) ...[
                Text(
                  text!,
                  style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: textStyle?.fontWeight),
                  textAlign: TextAlign.center,
                ),
              ],
              if (imageRight != null) ...[
                const SizedBox(
                  width: 4,
                ),
                imageRight!,
              ],
            ];

            if (reverse) {
              x = x.reversed.toList();
            }

            return x;
          }(),
        ),
      ),
    );
  }
}
