import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../profile/data/user_repository.dart';
import '../../startup/data/startup_repository.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return AuthRepository();
});

final userRepositoryProvider = Provider<UserRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return UserRepository();
});

final startupRepositoryProvider = Provider<StartupRepository?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return StartupRepository();
});

/// Uploads images and documents to Cloudinary; URLs are saved in Firestore.
final cloudinaryServiceProvider = Provider<CloudinaryService?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return CloudinaryService();
});
