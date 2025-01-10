import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';
import 'package:hermifyapp/base/constants/app_strings.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/login/mixin/signin_mixin.dart';
import 'package:hermifyapp/view/login/signup_view.dart';
import 'package:hermifyapp/view/widgets/auth_textfield.dart';

import 'package:provider/provider.dart';

class SigninView extends StatefulWidget {
  final HomeViewModel viewModel;
  const SigninView({super.key, required this.viewModel});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> with SigninMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (BuildContext context, value, _) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: AppColors.background,
            ),
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
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
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            onPressed: handleSignIn,
                            child: const Text(
                              AppStrings.signIn,
                              style: TextStyle(color: AppColors.background),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpView()),
                            );
                          },
                          child: const Text(
                            AppStrings.signUp,
                            style: TextStyle(color: AppColors.background),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1.0),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.silver,
                      ),
                      onPressed: widget.viewModel.signInWithGoogle,
                      label: const Text(
                        AppStrings.signInWithGoogle,
                        style: TextStyle(
                          color: AppColors.background,
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
