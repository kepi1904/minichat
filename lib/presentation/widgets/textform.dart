// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/services.dart';
import 'package:minichat/data/utils/constants.dart';
import 'package:minichat/data/values/app_colors.dart';

import '../../data/values/app_sizes.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    this.controller,
    this.onChanged,
    this.prefix,
    this.prefixIcon,
    this.prefixIconColor,
    this.sufix,
    this.sufixIcon,
    this.sufixIconColor,
    this.contentPadding,
    this.hintText,
    this.border,
    this.enableBorder,
    this.focusedBorder,
    this.errorBorder,
    this.validator,
    this.textInputType,
    this.obsecureText = false,
    this.autovalidateMode,
    this.errorText,
    this.onSaved,
    this.enable,
    this.filled,
    this.filledColor,
    this.textInputAction,
    this.focusNode,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
    this.style,
    this.line,
    this.onEditingComplete,
    required this.autofillHints,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? sufix;
  final Widget? sufixIcon;
  final Color? sufixIconColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final InputBorder? border;
  final InputBorder? enableBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final bool obsecureText;
  final AutovalidateMode? autovalidateMode;
  final String? errorText;
  final Function(String?)? onSaved;
  final bool? enable, filled;
  final Color? filledColor;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final TextStyle? style;
  final int? line;
  final void Function()? onEditingComplete;
  final List<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      onSaved: onSaved,
      focusNode: focusNode,
      controller: controller,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      validator: validator,
      keyboardType: textInputType,
      obscureText: obsecureText,
      initialValue: initialValue,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction ?? TextInputAction.next,
      style: style,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        fillColor: filledColor,
        filled: filled,
        errorText: errorText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: AppColor.grey,
          fontWeight: FontWeight.w400,
        ),
        prefix: prefix,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        suffix: sufix,
        suffixIcon: sufixIcon,
        suffixIconColor: sufixIconColor,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
                vertical: Sizes.p16, horizontal: Sizes.p16),
        enabledBorder: enableBorder ?? primaryEnable,
        border: border ?? primaryBorder,
        focusedBorder: focusedBorder ?? primaryFocused,
        errorBorder: errorBorder ?? primaryErrorBorder,
      ),
    );
  }
}
