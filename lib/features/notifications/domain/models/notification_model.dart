import 'package:equatable/equatable.dart';

enum NotificationType {
  order,
  promo,
  system;

  String get displayName {
    switch (this) {
      case NotificationType.order:
        return 'Order';
      case NotificationType.promo:
        return 'Promotion';
      case NotificationType.system:
        return 'System';
    }
  }
}

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, isRead, createdAt];
}
