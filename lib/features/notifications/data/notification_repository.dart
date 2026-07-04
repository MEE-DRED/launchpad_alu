import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';
import '../../applications/data/models/application.dart';
import 'models/app_notification.dart';

/// Creates and reads in-app notifications.
class NotificationRepository {
  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection(AppConstants.notificationsCollection);

  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _notifications
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(AppNotification.fromFirestore).toList());
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedId,
  }) async {
    try {
      await _notifications.add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.name,
        'read': false,
        if (relatedId != null) 'relatedId': relatedId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> notifyApplicationStatusChange({
    required Application application,
    required ApplicationStatus newStatus,
  }) async {
    final type = switch (newStatus) {
      ApplicationStatus.reviewed => NotificationType.applicationReviewed,
      ApplicationStatus.accepted => NotificationType.applicationAccepted,
      ApplicationStatus.rejected => NotificationType.applicationRejected,
      _ => NotificationType.general,
    };

    final title = switch (newStatus) {
      ApplicationStatus.reviewed => 'Application reviewed',
      ApplicationStatus.shortlisted => 'You were shortlisted!',
      ApplicationStatus.accepted => 'Congratulations — accepted!',
      ApplicationStatus.rejected => 'Application update',
      ApplicationStatus.pending => 'Application update',
    };

    final body =
        'Your application for "${application.opportunityTitle}" is now ${newStatus.label.toLowerCase()}.';

    await createNotification(
      userId: application.studentId,
      title: title,
      body: body,
      type: type,
      relatedId: application.id,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notifications.doc(notificationId).set(
        {'read': true},
        SetOptions(merge: true),
      );
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot =
          await _notifications.where('userId', isEqualTo: userId).get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.set(doc.reference, {'read': true}, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
