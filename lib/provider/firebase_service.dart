import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const _lastSignedInUserKey = 'lastSignedInUser';

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      if (!_validateEmail(email)) {
        throw Exception("Invalid email domain");
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveLastSignedInUser(userCredential.user?.email);
      return userCredential.user;
    } catch (e) {
      print("Error during Email/Password Sign-Up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (!_validateEmail(email)) {
        throw Exception("Invalid email domain");
      }

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveLastSignedInUser(userCredential.user?.email);
      return userCredential.user;
    } catch (e) {
      print("Error during Email/Password Sign-In: $e");
      return null;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle({bool isSignUp = false}) async {
    try {
      // Önceki Google oturumunu kapat
      await _googleSignIn.signOut();

      // Google Sign-In işlemini başlat
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("Google Sign-In cancelled by user");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile kimlik doğrulama
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (!_validateEmail(user?.email)) {
        await user?.delete();
        throw Exception("Invalid email domain");
      }

      await _saveLastSignedInUser(user?.email);

      if (isSignUp && userCredential.additionalUserInfo?.isNewUser == true) {
        print("New user signed up: ${user?.email}");
      }

      return user;
    } catch (e) {
      print("Error during Google Sign-In/Sign-Up: $e");
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print("Error fetchingæ FCM token: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _saveLastSignedInUser(String? email) async {
    if (email == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSignedInUserKey, email);
  }

  Future<String?> getLastSignedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSignedInUserKey);
  }

  bool _validateEmail(String? email) {
    if (email == null) return false;
    return email.endsWith('@sntyazilim.com.tr') ||
        email.endsWith('@sntakademi.com.tr') ||
        email.endsWith('@infoyatirim.com.tr');
  }

  static const _notificationsKey = 'cached_notifications';

  Future<void> cacheNotification(
      String title, String body, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notifications =
        prefs.getStringList('cached_notifications') ?? [];

    // Tarih ve saati ekleyerek bildirimi kaydet
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

  Future<List<String>> getCachedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_notificationsKey) ?? [];
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print("Subscribed to $topic");
    } catch (e) {
      print("Error subscribing to $topic: $e");
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print("Unsubscribed from $topic");
    } catch (e) {
      print("Error unsubscribing from $topic: $e");
    }
  }
}
