import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../notifications/data/models/app_notification.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/application.dart';

class ApplyController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> submit({
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String startupName,
    String? coverLetter,
    String? portfolioUrl,
    PlatformFile? resumeFile,
  }) async {
    state = const AsyncLoading();
    late String? applicationId;
    state = await AsyncValue.guard(() async {
      final appRepo = ref.read(applicationRepositoryProvider);
      final cloudinary = ref.read(cloudinaryServiceProvider);
      final profile = ref.read(currentUserProfileProvider).value;
      final uid = ref.read(authStateProvider).value?.uid;
      if (appRepo == null || profile == null || uid == null) {
        throw Failures.notAuthenticated;
      }

      final alreadyApplied = await appRepo.hasApplied(
        studentId: uid,
        opportunityId: opportunityId,
      );
      if (alreadyApplied) {
        throw const Failure('You have already applied to this opportunity.');
      }

      String? resumeUrl = profile.cvUrl;
      if (resumeFile != null && resumeFile.bytes != null && cloudinary != null) {
        resumeUrl = await cloudinary.uploadBytes(
          bytes: resumeFile.bytes!,
          folder: '${AppConstants.resumeStoragePath}/$uid',
          fileName: resumeFile.name,
          resourceType: CloudinaryResourceType.raw,
        );
      }

      final application = Application(
        id: '',
        opportunityId: opportunityId,
        opportunityTitle: opportunityTitle,
        startupId: startupId,
        startupName: startupName,
        studentId: uid,
        studentName: profile.fullName ?? profile.email,
        studentEmail: profile.email,
        status: ApplicationStatus.pending,
        resumeUrl: resumeUrl,
        coverLetter: coverLetter,
        portfolioUrl: portfolioUrl ?? profile.portfolioUrl,
      );

      applicationId = await appRepo.submitApplication(application: application);

      final notifRepo = ref.read(notificationRepositoryProvider);
      if (notifRepo != null) {
        await notifRepo.createNotification(
          userId: startupId,
          title: 'New application received',
          body:
              '${profile.fullName ?? profile.email} applied for "$opportunityTitle".',
          type: NotificationType.general,
          relatedId: applicationId,
        );
      }
    });
    return state.hasError ? null : applicationId;
  }
}

final applyControllerProvider =
    AsyncNotifierProvider<ApplyController, void>(ApplyController.new);

class ApplicationStatusController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateStatus({
    required Application application,
    required ApplicationStatus status,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final appRepo = ref.read(applicationRepositoryProvider);
      final notifRepo = ref.read(notificationRepositoryProvider);
      if (appRepo == null || notifRepo == null) throw Failures.network;

      await appRepo.updateStatus(
        applicationId: application.id,
        status: status,
      );
      await notifRepo.notifyApplicationStatusChange(
        application: application,
        newStatus: status,
      );
    });
  }
}

final applicationStatusControllerProvider =
    AsyncNotifierProvider<ApplicationStatusController, void>(
  ApplicationStatusController.new,
);
