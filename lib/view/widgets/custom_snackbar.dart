import 'package:flutter/material.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String label,
    Color backgroundColor = AppColors.softRed,
    Color textColor = AppColors.background,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(3),
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut,
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        content: Text(
          label,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
