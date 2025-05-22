// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:minichat/data/values/app_colors.dart';

import '../../data/values/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      this.backgroundColor,
      this.color,
      required this.onPressed,
      this.label,
      this.side,
      this.child,
      this.width,
      this.height,
      this.isFixed = false,
      this.padding,
      this.fontSize,
      this.margin,
      this.borderRadius,
      this.boxShadow,
      this.isLoading = false});

  final Color? color, backgroundColor;
  final String? label;
  final BorderSide? side;
  final Widget? child;
  final double? width, height, fontSize;
  final bool? isFixed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding, margin;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onPressed;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            elevation: 0,
            backgroundColor: backgroundColor ?? AppColor.kBlueLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label.toString(),
            style: const TextStyle(fontSize: Sizes.p16, color: AppColor.kWhite),
          )),
    );
  }
}
