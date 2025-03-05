import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../provider/firebase_service.dart';

class NotificationsWidget extends StatelessWidget {
  final FirebaseService firebaseService;

  const NotificationsWidget({
    Key? key,
    required this.firebaseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.notifications),
          FutureBuilder<int>(
            future: firebaseService.getUnreadNotificationCount(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data! > 0) {
                return Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '${snapshot.data}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      onPressed: () => _showNotifications(context),
    );
  }

  void _showNotifications(BuildContext context) async {
    final notifications = await firebaseService.getNotifications();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bildirimler'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification['title'] ?? 'Başlıksız'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['body'] ?? ''),
                      Text(
                        DateTime.parse(notification['timestamp']).toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    firebaseService.markNotificationAsRead(index);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                firebaseService.clearAllNotifications();
                Navigator.of(context).pop();
              },
              child: const Text('Tümünü Temizle'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    }
  }
}
