import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../data/models/user_profile.dart';

/// Streams the current Firebase [User]. Drives session persistence and routing.
final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  if (repo == null) return Stream<User?>.value(null);
  return repo.authStateChanges();
});

/// Whether a user is currently signed in.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).value != null;
});

/// Streams the signed-in user's Firestore profile.
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  final userRepo = ref.watch(userRepositoryProvider);
  if (uid == null || userRepo == null) return Stream.value(null);
  return userRepo.watchUser(uid);
});

/// Whether onboarding is complete for the current user.
final onboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProfileProvider).value?.onboardingComplete ??
      false;
});
