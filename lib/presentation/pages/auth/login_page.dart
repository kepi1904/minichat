import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minichat/presentation/widgets/common_text_small.dart';
import 'package:minichat/presentation/pages/auth/components/button_google.dart';
import 'package:minichat/data/providers/login_provider.dart';
import 'package:minichat/data/values/app_colors.dart';
import 'package:minichat/data/values/app_sizes.dart';
import 'package:minichat/data/values/app_strings.dart';
import 'package:minichat/presentation/widgets/primary_button.dart';
import 'package:minichat/presentation/widgets/textform.dart';
import 'package:minichat/presentation/pages/auth/components/dont_have_account.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginForm();
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(onWillPop: () async {
      SystemNavigator.pop();
      return true;
    }, child: SafeArea(
      child: Scaffold(
        body: Consumer<LoginProvider>(
          builder: (context, provider, child) {
            return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  child: Column(
                    children: [
                      gapH64,
                      CommonTextSmall(
                        text: Labels.miniChat,
                        size: size.width * 0.09,
                        weight: FontWeight.bold,
                        color: AppColor.kBlueDark,
                      ),
                      gapH16,
                      CommonTextSmall(
                        text: Labels.logintoContinueChatting,
                        size: size.width * 0.05,
                        weight: FontWeight.bold,
                        color: AppColor.grey,
                      ),
                      gapH32,

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
                        onEditingComplete: () =>
                            provider.focusNode.requestFocus(),
                      ),
                      gapH10,
                      // Password
                      TextForm(
                        controller: provider.passController,
                        hintText: Labels.password,
                        obsecureText: provider.isHide,
                        autofillHints: [AutofillHints.password],
                        textInputAction: TextInputAction.next,
                        focusNode: provider.focusNode,
                        enable: !provider.isLoading,
                        sufixIcon: GestureDetector(
                          onTap: provider.onHide,
                          child: Icon(
                            provider.isHide
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                        onEditingComplete: () => provider.doLogin(context),
                      ),

                      gapH100,
                      provider.isLoading != true
                          ? PrimaryButton(
                              label: Labels.login,
                              width: size.width,
                              height: 42.h,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  provider.doLogin(context);
                                }
                              })
                          : const CircularProgressIndicator(),
                      gapH20,
                      DontHaveAnAccount(),
                      gapH50,
                      ButtonGoogle(onPressed: () {
                        provider.onPressGoogle(context);
                      }),
                    ],
                  ),
                ));
          },
        ),
      ),
    ));
  }
}
