import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';

/// Firestore-backed user profile for students, startups, and admins.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.role,
    required this.email,
    this.fullName,
    this.program,
    this.year,
    this.skills = const [],
    this.interests = const [],
    this.cvUrl,
    this.portfolioUrl,
    this.linkedInUrl,
    this.profileImageUrl,
    this.onboardingComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final UserRole role;
  final String email;
  final String? fullName;
  final String? program;
  final String? year;
  final List<String> skills;
  final List<String> interests;
  final String? cvUrl;
  final String? portfolioUrl;
  final String? linkedInUrl;
  final String? profileImageUrl;
  final bool onboardingComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfile(
      uid: doc.id,
      role: UserRole.fromName(data['role'] as String?),
      email: data['email'] as String? ?? '',
      fullName: data['fullName'] as String?,
      program: data['program'] as String?,
      year: data['year'] as String?,
      skills: List<String>.from(data['skills'] ?? const []),
      interests: List<String>.from(data['interests'] ?? const []),
      cvUrl: data['cvUrl'] as String?,
      portfolioUrl: data['portfolioUrl'] as String?,
      linkedInUrl: data['linkedInUrl'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role.name,
      'email': email,
      if (fullName != null) 'fullName': fullName,
      if (program != null) 'program': program,
      if (year != null) 'year': year,
      'skills': skills,
      'interests': interests,
      if (cvUrl != null) 'cvUrl': cvUrl,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
      if (linkedInUrl != null) 'linkedInUrl': linkedInUrl,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'onboardingComplete': onboardingComplete,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? program,
    String? year,
    List<String>? skills,
    List<String>? interests,
    String? cvUrl,
    String? portfolioUrl,
    String? linkedInUrl,
    String? profileImageUrl,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      uid: uid,
      role: role,
      email: email,
      fullName: fullName ?? this.fullName,
      program: program ?? this.program,
      year: year ?? this.year,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      cvUrl: cvUrl ?? this.cvUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
