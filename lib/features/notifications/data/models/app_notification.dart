import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  applicationReviewed,
  applicationAccepted,
  applicationRejected,
  newOpportunity,
  general;

  static NotificationType fromName(String? value) {
    return NotificationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => NotificationType.general,
    );
  }
}

/// In-app notification stored in Firestore.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.read = false,
    this.relatedId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool read;
  final String? relatedId;
  final DateTime? createdAt;

  factory AppNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AppNotification(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: NotificationType.fromName(data['type'] as String?),
      read: data['read'] as bool? ?? false,
      relatedId: data['relatedId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'read': read,
      if (relatedId != null) 'relatedId': relatedId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
