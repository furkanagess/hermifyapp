import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hermifyapp/provider/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  User? _user;
  String? _fcmToken;
  List<String> _notifications = [];
  StreamSubscription<RemoteMessage>? _fcmSubscription;
  Map<String, bool> _topicSubscriptions = {};
  Map<String, bool> get topicSubscriptions => _topicSubscriptions;

  User? get user => _user;
  String? get fcmToken => _fcmToken;
  List<String> get notifications => _notifications;
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void toggleVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> initializeMessaging() async {
    _fcmToken = await _firebaseService.getFCMToken();
    await loadTopicSubscriptions();
    _setupFirebaseMessagingListener();
    notifyListeners();
  }

  Future<void> loadTopicSubscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    _topicSubscriptions = {
      'bildirimleri_goster': prefs.getBool('bildirimleri_goster') ?? false,
      'uygulama_bildirimleri': prefs.getBool('uygulama_bildirimleri') ?? false,
      'duyurular': prefs.getBool('duyurular') ?? false,
      'portfoy_bildirimleri': prefs.getBool('portfoy_bildirimleri') ?? false,
      'haber_bildirimleri': prefs.getBool('haber_bildirimleri') ?? false,
      'model_portfoy': prefs.getBool('model_portfoy') ?? false,
      'arastirma_raporlari': prefs.getBool('arastirma_raporlari') ?? false,
      'teknik_oneriler': prefs.getBool('teknik_oneriler') ?? false,
      'fiyat_bildirimleri': prefs.getBool('fiyat_bildirimleri') ?? false,
      'emir_bildirimleri': prefs.getBool('emir_bildirimleri') ?? false,
      'bilanco_bildirimleri': prefs.getBool('bilanco_bildirimleri') ?? false,
    };
    notifyListeners();
  }

  Future<void> checkUserSession() async {
    _user = _firebaseService.getCurrentUser();
    if (_user != null) {
      await initializeMessaging();
      await loadCachedNotifications();
    }
  }

  Future<void> toggleTopicSubscription(String topic, bool isSubscribed) async {
    final prefs = await SharedPreferences.getInstance();
    _topicSubscriptions[topic] = isSubscribed;
    await prefs.setBool(topic, isSubscribed);

    if (isSubscribed) {
      await _firebaseService.subscribeToTopic(topic);
    } else {
      await _firebaseService.unsubscribeFromTopic(topic);
    }
    notifyListeners();
    // printSubscribedTopics();
  }

  // void printSubscribedTopics() {
  //   final subscribedTopics = _topicSubscriptions.entries
  //       .where((entry) => entry.value)
  //       .map((entry) => entry.key)
  //       .toList();

  //   print(
  //       "Subscribed Topics: ${subscribedTopics.isNotEmpty ? subscribedTopics : 'None'}");
  // }

  Future<void> signInWithEmail(String email, String password) async {
    _user = await _firebaseService.signInWithEmailAndPassword(email, password);
    if (_user != null) {
      await initializeMessaging();
      await loadCachedNotifications();
    }
  }

  Future<void> signInWithGoogle() async {
    _user = await _firebaseService.signInWithGoogle();
    if (_user != null) {
      await initializeMessaging();
      await loadCachedNotifications();
    }
  }

  Future<void> _setupFirebaseMessagingListener() async {
    _fcmSubscription?.cancel(); // Mevcut dinleyici varsa iptal et
    _fcmSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      final data = message.data;

      if (notification != null) {
        await cacheNotification(
          notification.title ?? "No Title",
          notification.body ?? "No Body",
          data,
        );
        await loadCachedNotifications();
      }
    });
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_notifications');
    _notifications = [];
    notifyListeners();
  }

  Future<void> loadCachedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    _notifications = prefs.getStringList('cached_notifications') ?? [];
    notifyListeners();
  }

  Future<void> cacheNotification(
      String title, String body, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications =
        prefs.getStringList('cached_notifications') ?? [];

    String formattedDate = DateTime.now().toString();
    String formattedNotification = jsonEncode({
      'date': formattedDate,
      'title': title,
      'body': body,
      'data': data,
    });

    notifications.add(formattedNotification);
    await prefs.setStringList('cached_notifications', notifications);
  }

  Future<void> signOut(VoidCallback onSuccess) async {
    await _firebaseService.signOut();
    _user = null;
    _fcmToken = null;
    _notifications = [];

    await _fcmSubscription?.cancel();
    _fcmSubscription = null;

    onSuccess();
    notifyListeners();
  }

  @override
  void dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }
}
