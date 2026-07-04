import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';
import 'models/application.dart';

/// Application CRUD and status updates.
class ApplicationRepository {
  ApplicationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _applications =>
      _firestore.collection(AppConstants.applicationsCollection);

  Stream<List<Application>> watchStudentApplications(String studentId) {
    return _applications
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map(Application.fromFirestore).toList();
      items.sort(
        (a, b) => (b.appliedAt ?? DateTime(1970))
            .compareTo(a.appliedAt ?? DateTime(1970)),
      );
      return items;
    });
  }

  Stream<List<Application>> watchStartupApplications(String startupId) {
    return _applications
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map(Application.fromFirestore).toList();
      items.sort(
        (a, b) => (b.appliedAt ?? DateTime(1970))
            .compareTo(a.appliedAt ?? DateTime(1970)),
      );
      return items;
    });
  }

  Stream<List<Application>> watchOpportunityApplications(
    String opportunityId,
  ) {
    return _applications
        .where('opportunityId', isEqualTo: opportunityId)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map(Application.fromFirestore).toList();
      items.sort(
        (a, b) => (b.appliedAt ?? DateTime(1970))
            .compareTo(a.appliedAt ?? DateTime(1970)),
      );
      return items;
    });
  }

  Stream<Application?> watchApplication(String id) {
    return _applications.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Application.fromFirestore(doc);
    });
  }

  Future<bool> hasApplied({
    required String studentId,
    required String opportunityId,
  }) async {
    try {
      final snapshot = await _applications
          .where('studentId', isEqualTo: studentId)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<String> submitApplication({
    required Application application,
  }) async {
    try {
      final docRef = _applications.doc();
      await docRef.set({
        ...application.toFirestore(),
        'status': ApplicationStatus.pending.name,
        'appliedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> updateStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) async {
    try {
      await _applications.doc(applicationId).set(
        {
          'status': status.name,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
