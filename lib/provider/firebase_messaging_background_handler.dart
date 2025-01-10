import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// Arka planda gelen mesajları işleyen handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await cacheNotification(message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body");
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
