// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:minichat/data/values/app_colors.dart';

import '../values/app_sizes.dart';

const noBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
);

final primaryEnable = OutlineInputBorder(
  borderRadius: BorderRadius.circular(Sizes.p50),
  borderSide: const BorderSide(
    color: AppColor.grey,
  ),
);

OutlineInputBorder primaryBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(Sizes.p50),
  borderSide: const BorderSide(
    color: AppColor.grey,
    // width: 2,
  ),
);
OutlineInputBorder primaryFocused = OutlineInputBorder(
  borderRadius: BorderRadius.circular(Sizes.p50),
  borderSide: const BorderSide(
    color: AppColor.grey,
    // width: 2,
  ),
);
OutlineInputBorder primaryErrorBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(Sizes.p12),
  borderSide: const BorderSide(
    color: AppColor.red,
    // width: 2,
  ),
);

BoxShadow primaryShadow = BoxShadow(
  color: AppColor.red.withOpacity(0.1),
  spreadRadius: 4,
  blurRadius: 10,
  offset: const Offset(0, 3),
);

BoxShadow blackShadow = BoxShadow(
  color: AppColor.black.withOpacity(0.1),
  spreadRadius: 4,
  blurRadius: 10,
  offset: const Offset(0, 3),
);
