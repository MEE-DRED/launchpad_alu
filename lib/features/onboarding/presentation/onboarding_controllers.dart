import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../profile/presentation/profile_providers.dart';

/// Saves a student onboarding profile. File URLs live in Firestore via Cloudinary.
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
      final cloudinary = ref.read(cloudinaryServiceProvider);
      if (uid == null || userRepo == null) {
        throw Failures.notAuthenticated;
      }

      String? profileImageUrl;
      if (profileImage != null && cloudinary != null) {
        profileImageUrl = await cloudinary.uploadXFile(
          file: profileImage,
          folder: '${AppConstants.profileImageStoragePath}/$uid',
        );
      }

      String? cvUrl;
      if (cvFile != null && cvFile.bytes != null && cloudinary != null) {
        cvUrl = await cloudinary.uploadBytes(
          bytes: cvFile.bytes!,
          folder: '${AppConstants.cvStoragePath}/$uid',
          fileName: cvFile.name,
          resourceType: CloudinaryResourceType.raw,
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

/// Saves a startup onboarding profile. Logo URL stored in Firestore via Cloudinary.
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
      final cloudinary = ref.read(cloudinaryServiceProvider);
      if (uid == null || userRepo == null || startupRepo == null) {
        throw Failures.notAuthenticated;
      }

      String? logoUrl;
      if (logo != null && cloudinary != null) {
        logoUrl = await cloudinary.uploadXFile(
          file: logo,
          folder: '${AppConstants.logoStoragePath}/$uid',
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
