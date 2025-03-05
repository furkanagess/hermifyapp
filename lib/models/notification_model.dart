class NotificationModel {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    this.title,
    this.body,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
