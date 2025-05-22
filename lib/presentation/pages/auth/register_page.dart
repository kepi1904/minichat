import 'package:flutter/material.dart';

import 'package:minichat/data/providers/register_provider.dart';
import 'package:minichat/data/values/app_sizes.dart';
import 'package:minichat/data/values/app_strings.dart';
import 'package:minichat/presentation/widgets/primary_button.dart';
import 'package:minichat/presentation/widgets/textform.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:minichat/data/values/app_colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(child: Scaffold(
      body: Consumer<RegisterProvider>(builder: (context, provider, child) {
        return Form(
          key: provider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  Labels.createAccount,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.kBlueDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  Labels.registerToStartChatting,
                  style: TextStyle(fontSize: 16.sp, color: AppColor.grey),
                ),
                SizedBox(height: 32.h),

                // Name
                TextForm(
                  controller: provider.firstNameController,
                  hintText: Labels.firstName,
                  autofillHints: [],
                ),
                SizedBox(height: 16.h),
                // Name
                TextForm(
                  controller: provider.lastNameController,
                  hintText: Labels.lastName,
                  autofillHints: [],
                ),
                SizedBox(height: 16.h),

                TextForm(
                  controller: provider.emailController,
                  hintText: Labels.email,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: [AutofillHints.email],
                  enable: !provider.isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Labels.emailTidakBolehKosong;
                    }
                    final emailRegex =
                        RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return Labels.formatEmailTidakValid;
                    }
                    return null;
                  },
                ),
                gapH10,
                // Password
                TextForm(
                  controller: provider.passwordController,
                  hintText: Labels.password,
                  obsecureText: provider.isHide,
                  autofillHints: [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  focusNode: provider.focusNode,
                  enable: !provider.isLoading,
                  sufixIcon: GestureDetector(
                    onTap: provider.onHide,
                    child: Icon(
                      provider.isHide ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Labels.passwordTidakBolehKosong;
                    }
                    if (value.length < 6) {
                      return Labels.passwordMinimal6Karakter;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // Register Button
                provider.isLoading != true
                    ? PrimaryButton(
                        label: Labels.register,
                        width: size.width,
                        height: 42.h,
                        onPressed: () {
                          if (provider.formKey.currentState!.validate()) {
                            provider.register(
                              context,
                              provider.emailController.text,
                              provider.passwordController.text,
                              provider.firstNameController.text,
                              provider.lastNameController.text,
                            );
                          }
                        })
                    : Center(child: const CircularProgressIndicator()),

                SizedBox(height: 16.h),

                // Login Redirect
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: Labels.already,
                        style: TextStyle(color: AppColor.grey),
                        children: [
                          TextSpan(
                            text: Labels.login,
                            style: TextStyle(
                              color: AppColor.kBlueLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ));
  }
}
