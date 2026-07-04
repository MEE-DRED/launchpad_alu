import 'package:cloud_firestore/cloud_firestore.dart';

enum WorkMode {
  remote,
  hybrid,
  onSite;

  String get label {
    switch (this) {
      case WorkMode.remote:
        return 'Remote';
      case WorkMode.hybrid:
        return 'Hybrid';
      case WorkMode.onSite:
        return 'On-site';
    }
  }

  static WorkMode fromName(String? value) {
    return WorkMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => WorkMode.remote,
    );
  }
}

enum InternshipType {
  internship,
  project,
  partTime,
  fullTime;

  String get label {
    switch (this) {
      case InternshipType.internship:
        return 'Internship';
      case InternshipType.project:
        return 'Project';
      case InternshipType.partTime:
        return 'Part-time';
      case InternshipType.fullTime:
        return 'Full-time';
    }
  }

  static InternshipType fromName(String? value) {
    return InternshipType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => InternshipType.internship,
    );
  }
}

enum OpportunitySort { newest, deadline }

/// An internship opportunity posted by a startup.
class Opportunity {
  const Opportunity({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.skillsRequired,
    required this.duration,
    required this.internshipType,
    required this.workMode,
    required this.deadline,
    required this.openings,
    required this.responsibilities,
    required this.benefits,
    this.industry,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final List<String> skillsRequired;
  final String duration;
  final InternshipType internshipType;
  final WorkMode workMode;
  final DateTime deadline;
  final int openings;
  final String responsibilities;
  final String benefits;
  final String? industry;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isExpired => deadline.isBefore(DateTime.now());

  factory Opportunity.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Opportunity(
      id: doc.id,
      startupId: data['startupId'] as String? ?? '',
      startupName: data['startupName'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      skillsRequired: List<String>.from(data['skillsRequired'] ?? const []),
      duration: data['duration'] as String? ?? '',
      internshipType: InternshipType.fromName(data['internshipType'] as String?),
      workMode: WorkMode.fromName(data['workMode'] as String?),
      deadline: (data['deadline'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(days: 30)),
      openings: data['openings'] as int? ?? 1,
      responsibilities: data['responsibilities'] as String? ?? '',
      benefits: data['benefits'] as String? ?? '',
      industry: data['industry'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title.trim(),
      'description': description.trim(),
      'skillsRequired': skillsRequired,
      'duration': duration.trim(),
      'internshipType': internshipType.name,
      'workMode': workMode.name,
      'deadline': Timestamp.fromDate(deadline),
      'openings': openings,
      'responsibilities': responsibilities.trim(),
      'benefits': benefits.trim(),
      if (industry != null) 'industry': industry,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class OpportunityFilters {
  const OpportunityFilters({
    this.searchQuery = '',
    this.industry,
    this.skill,
    this.duration,
    this.internshipType,
    this.workMode,
    this.recentOnly = false,
    this.sort = OpportunitySort.newest,
  });

  final String searchQuery;
  final String? industry;
  final String? skill;
  final String? duration;
  final InternshipType? internshipType;
  final WorkMode? workMode;
  final bool recentOnly;
  final OpportunitySort sort;

  OpportunityFilters copyWith({
    String? searchQuery,
    String? industry,
    String? skill,
    String? duration,
    InternshipType? internshipType,
    WorkMode? workMode,
    bool? recentOnly,
    OpportunitySort? sort,
    bool clearIndustry = false,
    bool clearSkill = false,
    bool clearDuration = false,
    bool clearType = false,
    bool clearWorkMode = false,
  }) {
    return OpportunityFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      industry: clearIndustry ? null : (industry ?? this.industry),
      skill: clearSkill ? null : (skill ?? this.skill),
      duration: clearDuration ? null : (duration ?? this.duration),
      internshipType: clearType ? null : (internshipType ?? this.internshipType),
      workMode: clearWorkMode ? null : (workMode ?? this.workMode),
      recentOnly: recentOnly ?? this.recentOnly,
      sort: sort ?? this.sort,
    );
  }
}
