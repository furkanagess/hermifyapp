import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hermifyapp/base/constants/app_strings.dart';
import 'package:hermifyapp/firebase_options.dart';
import 'package:hermifyapp/provider/firebase_messaging_background_handler.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/home_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Analytics'i başlat
  final analytics = FirebaseAnalytics.instance;

  // Debug modunda Analytics'i etkinleştir
  if (kDebugMode) {
    // Debug collection'ı etkinleştir
    await analytics.setAnalyticsCollectionEnabled(true);

    // Test eventi gönder
    await analytics.logEvent(
      name: 'test_event',
      parameters: {
        'debug_mode': 'enabled',
        'timestamp': DateTime.now().toString(),
      },
    );

    // Debug mode'u etkinleştir
    await analytics.setUserProperty(
      name: 'debug_device',
      value: 'true',
    );
  }

  // Background handler'ı ayarla
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Uygulama açıkken gelen bildirimleri de cache'le
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final viewModel = HomeViewModel();
    await viewModel.cacheNotification(
      message.notification?.title ?? 'Başlıksız',
      message.notification?.body ?? '',
      message.data,
    );
  });

  // Bildirime tıklandığında uygulama kapalıysa
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      final viewModel = HomeViewModel();
      viewModel.cacheNotification(
        message.notification?.title ?? 'Başlıksız',
        message.notification?.body ?? '',
        message.data,
      );
    }
  });

  // Bildirime tıklandığında uygulama arka plandaysa
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final viewModel = HomeViewModel();
    viewModel.cacheNotification(
      message.notification?.title ?? 'Başlıksız',
      message.notification?.body ?? '',
      message.data,
    );
  });

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    return true;
  };
  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: MyApp(analytics: analytics),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMassgengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics;

  const MyApp({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(),
      home: const HomeView(),

      // Analytics navigator observer'ı ekle
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
