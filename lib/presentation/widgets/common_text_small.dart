// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minichat/data/values/app_colors.dart';

class CommonTextSmall extends StatelessWidget {
  const CommonTextSmall({
    super.key,
    required this.text,
    required this.size,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.flow,
    this.lineHeight,
    this.foreground,
  });

  final String text;
  final double size;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;
  final dynamic maxLines;
  final TextOverflow? flow;
  final dynamic lineHeight;
  final Paint? foreground;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: flow,
      style: GoogleFonts.zenOldMincho(
        textStyle: TextStyle(
          fontSize: size,
          color: color ?? AppColor.black,
          // letterSpacing: 10,
          height: lineHeight ?? 1.0,
          fontWeight: weight ?? FontWeight.w400,
          foreground: foreground,
        ),
      ),
    );
  }
}
