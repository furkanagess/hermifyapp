// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';
import 'package:hermifyapp/base/constants/app_strings.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/login/mixin/signup_mixin.dart';
import 'package:hermifyapp/view/widgets/auth_textfield.dart';

import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.silver),
        title: const Text(
          AppStrings.signUp,
          style: TextStyle(color: AppColors.silver),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/app_logo_bg.png",
                height: 200,
                width: 220,
              ),
              const SizedBox(height: 50),
              AuthTextfield(
                controller: emailController,
                label: AppStrings.email,
              ),
              const SizedBox(height: 16),
              Consumer<HomeViewModel>(
                builder: (context, visibilityProvider, child) {
                  return AuthTextfield(
                    controller: passwordController,
                    label: AppStrings.password,
                    obscureText: !visibilityProvider.isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        visibilityProvider.isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.silver,
                      ),
                      onPressed: visibilityProvider.toggleVisibility,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<HomeViewModel>(
                builder: (context, visibilityProvider, child) {
                  return AuthTextfield(
                    controller: confirmPasswordController,
                    label: AppStrings.passwordAgain,
                    obscureText: !visibilityProvider.isPasswordVisible,
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: handleSignUp,
                      child: const Text(
                        AppStrings.signUp,
                        style: TextStyle(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 170),
            ],
          ),
        ),
      ),
    );
  }
}
