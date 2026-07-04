import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus {
  pending,
  reviewed,
  shortlisted,
  accepted,
  rejected;

  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.reviewed:
        return 'Reviewed';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  static ApplicationStatus fromName(String? value) {
    return ApplicationStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

/// A student's application to an opportunity.
class Application {
  const Application({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.startupId,
    required this.startupName,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.status,
    this.resumeUrl,
    this.coverLetter,
    this.portfolioUrl,
    this.appliedAt,
    this.updatedAt,
  });

  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String startupId;
  final String startupName;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final ApplicationStatus status;
  final String? resumeUrl;
  final String? coverLetter;
  final String? portfolioUrl;
  final DateTime? appliedAt;
  final DateTime? updatedAt;

  factory Application.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return Application(
      id: doc.id,
      opportunityId: data['opportunityId'] as String? ?? '',
      opportunityTitle: data['opportunityTitle'] as String? ?? '',
      startupId: data['startupId'] as String? ?? '',
      startupName: data['startupName'] as String? ?? '',
      studentId: data['studentId'] as String? ?? '',
      studentName: data['studentName'] as String? ?? '',
      studentEmail: data['studentEmail'] as String? ?? '',
      status: ApplicationStatus.fromName(data['status'] as String?),
      resumeUrl: data['resumeUrl'] as String?,
      coverLetter: data['coverLetter'] as String?,
      portfolioUrl: data['portfolioUrl'] as String?,
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'startupId': startupId,
      'startupName': startupName,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'status': status.name,
      if (resumeUrl != null) 'resumeUrl': resumeUrl,
      if (coverLetter != null) 'coverLetter': coverLetter,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
