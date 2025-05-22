import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:minichat/data/values/app_strings.dart';
import 'package:minichat/presentation/pages/auth/register_page.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: Labels.dontHaveAnAccount,
          style: TextStyle(color: AppColor.grey),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              text: Labels.register,
              style: TextStyle(
                color: AppColor.kBlueLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
