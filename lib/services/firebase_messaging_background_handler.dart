import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final repository = NotificationRepository();

  final notification = NotificationModel(
    title: message.notification?.title,
    body: message.notification?.body,
    data: message.data,
    timestamp: DateTime.now(),
  );

  await repository.saveNotification(notification);
}
