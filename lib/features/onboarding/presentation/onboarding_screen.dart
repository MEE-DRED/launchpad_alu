import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../profile/presentation/profile_providers.dart';
import 'startup_onboarding_screen.dart';
import 'student_onboarding_screen.dart';

/// Routes the user to the correct onboarding flow based on their role.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: AppLoading(label: 'Loading your profile...'),
      ),
      error: (_, __) => const StudentOnboardingScreen(),
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: AppLoading(label: 'Setting up your account...'),
          );
        }

        if (profile.role == UserRole.startup) {
          return const StartupOnboardingScreen();
        }
        return const StudentOnboardingScreen();
      },
    );
  }
}
