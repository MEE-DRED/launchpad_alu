import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';
import 'models/startup_profile.dart';

/// Reads and writes startup documents in Firestore.
class StartupRepository {
  StartupRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _startups =>
      _firestore.collection(AppConstants.startupsCollection);

  Stream<StartupProfile?> watchStartupByFounder(String founderId) {
    return _startups
        .where('founderId', isEqualTo: founderId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return StartupProfile.fromFirestore(snapshot.docs.first);
    });
  }

  Future<StartupProfile?> getStartupByFounder(String founderId) async {
    try {
      final snapshot = await _startups
          .where('founderId', isEqualTo: founderId)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return StartupProfile.fromFirestore(snapshot.docs.first);
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> saveStartupProfile({
    required String founderId,
    required String name,
    required String description,
    required String industry,
    required int teamSize,
    required String founderName,
    String? logoUrl,
    String? website,
    String? contactEmail,
    String? contactPhone,
  }) async {
    try {
      final existing = await getStartupByFounder(founderId);
      final docRef = existing != null
          ? _startups.doc(existing.id)
          : _startups.doc(founderId);

      await docRef.set(
        {
          'founderId': founderId,
          'name': name.trim(),
          'description': description.trim(),
          'industry': industry.trim(),
          'teamSize': teamSize,
          'founderName': founderName.trim(),
          if (logoUrl != null) 'logoUrl': logoUrl,
          if (website != null) 'website': website.trim(),
          if (contactEmail != null) 'contactEmail': contactEmail.trim(),
          if (contactPhone != null) 'contactPhone': contactPhone.trim(),
          'verified': false,
          'createdAt': existing == null
              ? FieldValue.serverTimestamp()
              : existing.createdAt != null
                  ? Timestamp.fromDate(existing.createdAt!)
                  : FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
