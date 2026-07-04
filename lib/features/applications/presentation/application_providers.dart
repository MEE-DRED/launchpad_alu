import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/application.dart';

final studentApplicationsProvider =
    StreamProvider<List<Application>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value([]);
  return repo.watchStudentApplications(uid);
});

final startupApplicationsProvider =
    StreamProvider<List<Application>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value([]);
  return repo.watchStartupApplications(uid);
});

final applicationProvider =
    StreamProvider.family<Application?, String>((ref, id) {
  final repo = ref.watch(applicationRepositoryProvider);
  if (repo == null) return Stream.value(null);
  return repo.watchApplication(id);
});

final hasAppliedProvider =
    FutureProvider.family<bool, String>((ref, opportunityId) async {
  final repo = ref.read(applicationRepositoryProvider);
  final uid = ref.read(authStateProvider).value?.uid;
  if (repo == null || uid == null) return false;
  return repo.hasApplied(studentId: uid, opportunityId: opportunityId);
});
