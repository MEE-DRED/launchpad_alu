import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/auth_providers.dart';
import 'profile_providers.dart';

/// Profile tab showing the signed-in user's details.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final authUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load profile')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: profile.profileImageUrl != null
                      ? CachedNetworkImageProvider(profile.profileImageUrl!)
                      : null,
                  child: profile.profileImageUrl == null
                      ? const Icon(Icons.person,
                          size: 48, color: AppColors.primary)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  profile.fullName ?? authUser?.email ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  _roleLabel(profile.role),
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: profile.email,
              ),
              if (profile.program != null)
                _InfoTile(
                  icon: Icons.school_outlined,
                  label: 'Program',
                  value: profile.program!,
                ),
              if (profile.year != null)
                _InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Year',
                  value: profile.year!,
                ),
              if (profile.skills.isNotEmpty)
                _InfoTile(
                  icon: Icons.build_outlined,
                  label: 'Skills',
                  value: profile.skills.join(', '),
                ),
              if (profile.interests.isNotEmpty)
                _InfoTile(
                  icon: Icons.interests_outlined,
                  label: 'Interests',
                  value: profile.interests.join(', '),
                ),
              if (profile.linkedInUrl != null)
                _InfoTile(
                  icon: Icons.link_outlined,
                  label: 'LinkedIn',
                  value: profile.linkedInUrl!,
                ),
              if (profile.role == UserRole.startup) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.dashboard_outlined),
                  title: const Text('Startup dashboard'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.startupDashboard),
                ),
              ],
              if (profile.role == UserRole.admin) ...[
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: const Text('Admin panel'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.admin),
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => ref.read(authRepositoryProvider)?.signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.startup:
        return 'Startup founder';
      case UserRole.admin:
        return 'Administrator';
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
