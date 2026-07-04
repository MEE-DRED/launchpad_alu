import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../profile/presentation/profile_providers.dart';

/// Saves a student onboarding profile to Firestore and Storage.
class StudentOnboardingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String fullName,
    required String program,
    required String year,
    required List<String> skills,
    required List<String> interests,
    String? portfolioUrl,
    String? linkedInUrl,
    XFile? profileImage,
    PlatformFile? cvFile,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authStateProvider).value?.uid;
      final userRepo = ref.read(userRepositoryProvider);
      final storage = ref.read(storageServiceProvider);
      if (uid == null || userRepo == null || storage == null) {
        throw Failures.notAuthenticated;
      }

      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await storage.uploadXFile(
          file: profileImage,
          path:
              '${AppConstants.profileImageStoragePath}/$uid/${DateTime.now().millisecondsSinceEpoch}',
          contentType: 'image/jpeg',
        );
      }

      String? cvUrl;
      if (cvFile != null && cvFile.bytes != null) {
        cvUrl = await storage.uploadBytes(
          bytes: cvFile.bytes!,
          path:
              '${AppConstants.cvStoragePath}/$uid/${cvFile.name}',
          contentType: cvFile.extension == 'pdf'
              ? 'application/pdf'
              : 'application/octet-stream',
        );
      }

      await userRepo.saveStudentProfile(
        uid: uid,
        fullName: fullName,
        program: program,
        year: year,
        skills: skills,
        interests: interests,
        cvUrl: cvUrl,
        portfolioUrl: portfolioUrl,
        linkedInUrl: linkedInUrl,
        profileImageUrl: profileImageUrl,
      );
    });
  }
}

final studentOnboardingControllerProvider =
    AsyncNotifierProvider<StudentOnboardingController, void>(
  StudentOnboardingController.new,
);

/// Saves a startup onboarding profile to Firestore and Storage.
class StartupOnboardingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String name,
    required String description,
    required String industry,
    required int teamSize,
    required String founderName,
    String? website,
    String? contactEmail,
    String? contactPhone,
    XFile? logo,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authStateProvider).value?.uid;
      final userRepo = ref.read(userRepositoryProvider);
      final startupRepo = ref.read(startupRepositoryProvider);
      final storage = ref.read(storageServiceProvider);
      if (uid == null ||
          userRepo == null ||
          startupRepo == null ||
          storage == null) {
        throw Failures.notAuthenticated;
      }

      String? logoUrl;
      if (logo != null) {
        logoUrl = await storage.uploadXFile(
          file: logo,
          path:
              '${AppConstants.logoStoragePath}/$uid/${DateTime.now().millisecondsSinceEpoch}',
          contentType: 'image/jpeg',
        );
      }

      await startupRepo.saveStartupProfile(
        founderId: uid,
        name: name,
        description: description,
        industry: industry,
        teamSize: teamSize,
        founderName: founderName,
        logoUrl: logoUrl,
        website: website,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
      );

      await userRepo.markOnboardingComplete(uid);
    });
  }
}

final startupOnboardingControllerProvider =
    AsyncNotifierProvider<StartupOnboardingController, void>(
  StartupOnboardingController.new,
);
