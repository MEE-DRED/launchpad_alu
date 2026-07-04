/// App-wide constant values that don't belong to a single feature.
class AppConstants {
  const AppConstants._();

  static const String appName = 'ALU Internship Connect';
  static const String appTagline = 'Connecting ALU students with startups';

  /// Firestore collection names. Centralised to avoid typos across repositories.
  static const String usersCollection = 'users';
  static const String startupsCollection = 'startups';
  static const String opportunitiesCollection = 'opportunities';
  static const String applicationsCollection = 'applications';
  static const String bookmarksCollection = 'bookmarks';
  static const String notificationsCollection = 'notifications';
  static const String messagesCollection = 'messages';

  /// Cloud Storage folders.
  static const String cvStoragePath = 'cvs';
  static const String logoStoragePath = 'logos';
  static const String profileImageStoragePath = 'profile_images';
  static const String resumeStoragePath = 'resumes';

  /// Pagination defaults.
  static const int pageSize = 20;
}

/// The set of roles a user can hold. Stored as the string [name] in Firestore.
enum UserRole {
  student,
  startup,
  admin;

  static UserRole fromName(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.student,
    );
  }
}
