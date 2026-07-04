/// Centralised route paths and names used with go_router.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String opportunities = '/opportunities';
  static const String createOpportunity = '/opportunities/create';
  static const String applications = '/applications';
  static const String startupDashboard = '/startup';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String admin = '/admin';

  static String opportunityDetail(String id) => '/opportunities/$id';
  static String editOpportunity(String id) => '/opportunities/$id/edit';
  static String applyToOpportunity(String id) => '/opportunities/$id/apply';
  static String startupProfile(String id) => '/startups/$id';
  static String applicationDetail(String id) => '/applications/$id';
}
