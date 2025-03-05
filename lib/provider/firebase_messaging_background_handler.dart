import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Arka planda gelen mesajları işleyen handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> notifications =
      prefs.getStringList('cached_notifications') ?? [];

  String formattedNotification = jsonEncode({
    'date': DateTime.now().toString(),
    'title': message.notification?.title ?? 'Başlıksız',
    'body': message.notification?.body ?? '',
    'data': message.data,
    'isRead': false,
  });

  notifications.add(formattedNotification);
  await prefs.setStringList('cached_notifications', notifications);
}

/// Bildirimleri cache'leyen fonksiyon
Future<void> cacheNotification(String title, String body) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> notifications =
      prefs.getStringList('cached_notifications') ?? [];

  // Tarih ve saati ekleyerek bildirimi kaydet
  String formattedDate =
      DateFormat('dd/MM/yyyy : HH:mm').format(DateTime.now());
  String formattedNotification = "$formattedDate - $title: $body";

  notifications.add(formattedNotification);
  await prefs.setStringList('cached_notifications', notifications);
}
