import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/firebase_error_mapper.dart';
import 'models/user_profile.dart';

/// Reads and writes user documents in Firestore.
class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(AppConstants.usersCollection);

  Stream<UserProfile?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    });
  }

  Future<UserProfile?> getUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> createUser({
    required String uid,
    required String email,
    required UserRole role,
  }) async {
    try {
      await _users.doc(uid).set({
        'role': role.name,
        'email': email.trim(),
        'skills': <String>[],
        'interests': <String>[],
        'onboardingComplete': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> saveStudentProfile({
    required String uid,
    required String fullName,
    required String program,
    required String year,
    required List<String> skills,
    required List<String> interests,
    String? cvUrl,
    String? portfolioUrl,
    String? linkedInUrl,
    String? profileImageUrl,
  }) async {
    try {
      await _users.doc(uid).set(
        {
          'fullName': fullName.trim(),
          'program': program.trim(),
          'year': year.trim(),
          'skills': skills,
          'interests': interests,
          if (cvUrl != null) 'cvUrl': cvUrl,
          if (portfolioUrl != null) 'portfolioUrl': portfolioUrl.trim(),
          if (linkedInUrl != null) 'linkedInUrl': linkedInUrl.trim(),
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
          'onboardingComplete': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }

  Future<void> markOnboardingComplete(String uid) async {
    try {
      await _users.doc(uid).set(
        {
          'onboardingComplete': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      throw FirebaseErrorMapper.map(error);
    }
  }
}
