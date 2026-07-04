import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/application_status_chip.dart';
import '../../profile/presentation/profile_providers.dart';
import 'application_providers.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final isStartup = profile?.role == UserRole.startup;

    return Scaffold(
      appBar: AppBar(
        title: Text(isStartup ? 'Applicants' : 'My applications'),
      ),
      body: isStartup
          ? const _StartupApplicationsList()
          : const _StudentApplicationsList(),
    );
  }
}

class _StudentApplicationsList extends ConsumerWidget {
  const _StudentApplicationsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(studentApplicationsProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return applicationsAsync.when(
      loading: () => const AppLoading(label: 'Loading applications...'),
      error: (_, _) => const AppEmptyState(
        title: 'Could not load applications',
        icon: Icons.error_outline,
      ),
      data: (items) {
        if (items.isEmpty) {
          return const AppEmptyState(
            title: 'No applications yet',
            message: 'Apply to opportunities to track your progress here.',
            icon: Icons.assignment_outlined,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final app = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () => context.push(AppRoutes.applicationDetail(app.id)),
                title: Text(
                  app.opportunityTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${app.startupName} · Applied ${app.appliedAt != null ? dateFormat.format(app.appliedAt!) : ''}',
                ),
                trailing: ApplicationStatusChip(status: app.status),
              ),
            );
          },
        );
      },
    );
  }
}

class _StartupApplicationsList extends ConsumerWidget {
  const _StartupApplicationsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(startupApplicationsProvider);
    final dateFormat = DateFormat('MMM d, yyyy');

    return applicationsAsync.when(
      loading: () => const AppLoading(label: 'Loading applicants...'),
      error: (_, _) => const AppEmptyState(
        title: 'Could not load applicants',
        icon: Icons.error_outline,
      ),
      data: (items) {
        if (items.isEmpty) {
          return const AppEmptyState(
            title: 'No applicants yet',
            message: 'Students will appear here when they apply.',
            icon: Icons.people_outline,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final app = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () => context.push(AppRoutes.applicationDetail(app.id)),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    app.studentName.isNotEmpty
                        ? app.studentName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                title: Text(
                  app.studentName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${app.opportunityTitle} · ${dateFormat.format(app.appliedAt ?? DateTime.now())}',
                ),
                trailing: ApplicationStatusChip(status: app.status),
              ),
            );
          },
        );
      },
    );
  }
}
