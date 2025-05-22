// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:minichat/data/values/app_assets.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:minichat/presentation/widgets/common_text_small.dart';
import 'package:minichat/data/values/app_sizes.dart';
import 'package:minichat/data/values/app_strings.dart';

class ButtonGoogle extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonGoogle({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColor.white, // Sesuaikan dengan warna yang sesuai
          side: const BorderSide(color: AppColor.black), // Border hitam
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onPressed: onPressed, // Menggunakan parameter `onPressed`
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAsset.icGoogle,
              width: size.width * 0.06,
            ),
            gapW8,
            CommonTextSmall(
              color: AppColor.black, // Sesuaikan warna teks
              text: Labels.loginWithGoogle,
              size: size.width * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
