import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  static const String _storageKey = 'notifications';

  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_storageKey) ?? [];

    return notificationsJson.map((json) {
      return NotificationModel.fromJson(jsonDecode(json));
    }).toList();
  }

  Future<void> saveNotification(NotificationModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_storageKey) ?? [];

    notifications.add(jsonEncode(notification.toJson()));
    await prefs.setStringList(_storageKey, notifications);
  }

  Future<void> markAsRead(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_storageKey) ?? [];

    if (index >= 0 && index < notifications.length) {
      var notification = NotificationModel.fromJson(
        jsonDecode(notifications[index]),
      );
      var updatedNotification = NotificationModel(
        title: notification.title,
        body: notification.body,
        data: notification.data,
        timestamp: notification.timestamp,
        isRead: true,
      );

      notifications[index] = jsonEncode(updatedNotification.toJson());
      await prefs.setStringList(_storageKey, notifications);
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, []);
  }
}
