import 'package:cloud_firestore/cloud_firestore.dart';

/// A startup organisation profile linked to a founder [UserProfile].
class StartupProfile {
  const StartupProfile({
    required this.id,
    required this.founderId,
    required this.name,
    required this.description,
    required this.industry,
    required this.teamSize,
    required this.founderName,
    this.logoUrl,
    this.website,
    this.contactEmail,
    this.contactPhone,
    this.verified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String founderId;
  final String name;
  final String description;
  final String industry;
  final int teamSize;
  final String founderName;
  final String? logoUrl;
  final String? website;
  final String? contactEmail;
  final String? contactPhone;
  final bool verified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory StartupProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return StartupProfile(
      id: doc.id,
      founderId: data['founderId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      industry: data['industry'] as String? ?? '',
      teamSize: data['teamSize'] as int? ?? 1,
      founderName: data['founderName'] as String? ?? '',
      logoUrl: data['logoUrl'] as String?,
      website: data['website'] as String?,
      contactEmail: data['contactEmail'] as String?,
      contactPhone: data['contactPhone'] as String?,
      verified: data['verified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'founderId': founderId,
      'name': name,
      'description': description,
      'industry': industry,
      'teamSize': teamSize,
      'founderName': founderName,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (website != null) 'website': website,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactPhone != null) 'contactPhone': contactPhone,
      'verified': verified,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
