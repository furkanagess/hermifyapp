import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hermifyapp/base/constants/app_colors.dart';
import 'package:hermifyapp/base/constants/app_strings.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/notification/notification_detail_view.dart';
import 'package:hermifyapp/view/settings/settings_view.dart';
import 'package:intl/intl.dart';

class NotificationsView extends StatefulWidget {
  final HomeViewModel viewModel;
  const NotificationsView({super.key, required this.viewModel});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.viewModel.notifications.isEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.softRed,
              onPressed: () =>
                  _showConfirmationDialog(context, widget.viewModel),
              child: const Icon(
                Icons.delete,
                color: AppColors.background,
              ),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.notifications,
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.silver,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsView(
                    viewModel: widget.viewModel,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: widget.viewModel.notifications.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.noNotifications,
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.white.withOpacity(0.5),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: widget.viewModel.notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(
                            context, widget.viewModel.notifications[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text(
            AppStrings.clearNotifications,
            style: TextStyle(color: AppColors.white),
          ),
          content: const Text(
            AppStrings.clearNotificationsConfirmation,
            style: TextStyle(color: AppColors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.clearNotifications();
                Navigator.of(context).pop();
              },
              child: const Text(
                AppStrings.delete,
                style: TextStyle(color: AppColors.softRed),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, String notification) {
    try {
      final Map<String, dynamic> notificationData = jsonDecode(notification);
      final String title = notificationData['title'] ?? AppStrings.noTitle;
      final String body = notificationData['body'] ?? AppStrings.noBody;
      final String date = notificationData['date'] ?? AppStrings.noDate;
      final Map<String, dynamic> data = notificationData['data'] ?? {};

      String formattedDate =
          DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.parse(date));

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotificationDetailPage(notification: notification),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              border: Border.all(
                color: AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                if (data.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.dataTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    data.toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      final parts = notification.split(' - ');
      final date = parts.isNotEmpty ? parts[0] : "";

      final String title =
          parts.length > 1 ? parts[1].split(':')[0] : AppStrings.noTitle;
      final String body =
          parts.length > 1 ? parts[1].split(':')[1] : AppStrings.noBody;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotificationDetailPage(notification: notification),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(
                color: AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
