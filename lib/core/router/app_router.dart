import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_screen.dart';
import '../../features/applications/presentation/application_detail_screen.dart';
import '../../features/applications/presentation/apply_screen.dart';
import '../../features/applications/presentation/applications_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/opportunities/presentation/create_opportunity_screen.dart';
import '../../features/opportunities/presentation/opportunity_detail_screen.dart';
import '../../features/opportunities/presentation/opportunities_screen.dart';
import '../../features/profile/presentation/profile_providers.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/startup/presentation/startup_dashboard_screen.dart';
import '../../features/startup/presentation/startup_profile_screen.dart';
import 'app_routes.dart';

/// Provides the app's [GoRouter], rebuilding redirects when auth/profile change.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final profileState = ref.watch(currentUserProfileProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _GoRouterRefreshStream(ref),
    redirect: (context, state) {
      final isAuthLoading = authState.isLoading;
      final isLoggedIn = authState.value != null;
      final location = state.matchedLocation;

      final onSplash = location == AppRoutes.splash;
      final onAuthRoute = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.forgotPassword;
      final onOnboarding = location == AppRoutes.onboarding;

      if (isAuthLoading) {
        return onSplash ? null : AppRoutes.splash;
      }

      if (!isLoggedIn) {
        return onAuthRoute ? null : AppRoutes.login;
      }

      if (profileState.isLoading) {
        return onSplash ? null : AppRoutes.splash;
      }

      final onboardingComplete =
          profileState.value?.onboardingComplete ?? false;

      if (!onboardingComplete) {
        return onOnboarding ? null : AppRoutes.onboarding;
      }

      if (onSplash || onAuthRoute || onOnboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomeShell(),
      ),
      GoRoute(
        path: AppRoutes.opportunities,
        builder: (_, _) => const OpportunitiesScreen(),
      ),
      GoRoute(
        path: AppRoutes.createOpportunity,
        builder: (_, _) => const CreateOpportunityScreen(),
      ),
      GoRoute(
        path: '/opportunities/:id',
        builder: (_, state) => OpportunityDetailScreen(
          opportunityId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/opportunities/:id/edit',
        builder: (_, state) => CreateOpportunityScreen(
          opportunityId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/opportunities/:id/apply',
        builder: (_, state) => ApplyScreen(
          opportunityId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/startups/:id',
        builder: (_, state) => StartupProfileScreen(
          startupId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.startupDashboard,
        builder: (_, _) => const StartupDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.applications,
        builder: (_, _) => const ApplicationsScreen(),
      ),
      GoRoute(
        path: '/applications/:id',
        builder: (_, state) => ApplicationDetailScreen(
          applicationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.admin,
        builder: (_, _) => const AdminScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
    ref.listen(currentUserProfileProvider, (_, _) => notifyListeners());
  }
}
