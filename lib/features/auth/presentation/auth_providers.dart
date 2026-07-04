import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/services/storage_service.dart';
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

final storageServiceProvider = Provider<StorageService?>((ref) {
  final firebaseReady = ref.watch(firebaseReadyProvider);
  if (!firebaseReady) return null;
  return StorageService();
});
