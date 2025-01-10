import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';
import 'package:hermifyapp/base/constants/app_strings.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/home_view.dart';
import 'package:hermifyapp/view/settings/mixin/settings_view_mixin.dart';
import 'package:hermifyapp/view/widgets/custom_snackbar.dart';

import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  final HomeViewModel viewModel;
  const SettingsView({super.key, required this.viewModel});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SettingsViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              widget.viewModel.user?.email ?? AppStrings.noMail,
              style: const TextStyle(color: AppColors.white, fontSize: 20),
            ),
          ),
          const Divider(color: AppColors.white),
          SizedBox(height: 20),
          if (widget.viewModel.fcmToken != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.fcmTokenLabel,
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.viewModel.fcmToken!,
                          style: const TextStyle(
                            color: AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          _copyToClipboard(context, widget.viewModel.fcmToken!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30),
          const Divider(color: AppColors.white),
          ...topics.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.value,
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                  Consumer<HomeViewModel>(
                    builder: (context, viewModel, child) {
                      final isSubscribed =
                          viewModel.topicSubscriptions[entry.key] ?? false;
                      return IconButton(
                        icon: Icon(
                          isSubscribed
                              ? Icons.notifications_active
                              : Icons.notifications_off_outlined,
                          color: isSubscribed
                              ? AppColors.primary
                              : AppColors.silver.withOpacity(0.5),
                        ),
                        onPressed: () async {
                          await viewModel.toggleTopicSubscription(
                              entry.key, !isSubscribed);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.viewModel.signOut(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeView()));
            }),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.softRed),
            child: const Text(
              AppStrings.signOut,
              style: TextStyle(color: AppColors.background),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    CustomSnackbar.show(
        context: context,
        label: AppStrings.fcmTokenCopied,
        backgroundColor: AppColors.primary);
  }
}
