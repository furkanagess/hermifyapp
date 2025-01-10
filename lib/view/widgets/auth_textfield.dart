import 'package:flutter/material.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';

class AuthTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  bool? obscureText = false;
  Widget? suffixIcon;
  AuthTextfield(
      {super.key,
      required this.controller,
      required this.label,
      this.obscureText,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.primary,
      obscureText: obscureText ?? false,
      controller: controller,
      style: const TextStyle(color: AppColors.silver),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        focusColor: AppColors.primary,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(16),
        ),
        labelStyle: TextStyle(color: AppColors.white.withOpacity(0.5)),
        labelText: label,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
    );
  }
}
