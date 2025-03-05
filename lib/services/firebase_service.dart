import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';

class FirebaseService {
  final NotificationRepository _notificationRepository;

  FirebaseService({
    NotificationRepository? notificationRepository,
  }) : _notificationRepository =
            notificationRepository ?? NotificationRepository();

  Future<void> initialize() async {
    // Foreground handler
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Uygulama açıkken bildirime tıklanınca
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // İzinleri iste
    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final notification = NotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      timestamp: DateTime.now(),
    );

    await _notificationRepository.saveNotification(notification);
  }

  Future<List<NotificationModel>> getNotifications() {
    return _notificationRepository.getNotifications();
  }

  Future<void> markAsRead(int index) {
    return _notificationRepository.markAsRead(index);
  }

  Future<void> clearAllNotifications() {
    return _notificationRepository.clearAll();
  }

  Future<int> getUnreadCount() async {
    final notifications = await getNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}
