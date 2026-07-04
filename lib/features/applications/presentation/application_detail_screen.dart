import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/application_status_chip.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/application.dart';
import 'application_controllers.dart';
import 'application_providers.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({super.key, required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync = ref.watch(applicationProvider(applicationId));
    final profile = ref.watch(currentUserProfileProvider).value;
    final isStartup = profile?.role == UserRole.startup;

    return applicationAsync.when(
      loading: () => const Scaffold(
        body: AppLoading(label: 'Loading application...'),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load application')),
      ),
      data: (app) {
        if (app == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Application not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Application'),
            actions: [
              ApplicationStatusChip(status: app.status),
              const SizedBox(width: 12),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                app.opportunityTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isStartup
                    ? 'Applicant: ${app.studentName}'
                    : 'Startup: ${app.startupName}',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              if (isStartup) ...[
                const SizedBox(height: 4),
                Text(app.studentEmail),
              ],
              const SizedBox(height: 24),
              if (!isStartup) ...[
                Text(
                  'Application timeline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                ApplicationTimeline(status: app.status),
              ],
              if (app.coverLetter != null) ...[
                _Section(title: 'Cover letter', body: app.coverLetter!),
              ],
              if (app.portfolioUrl != null) ...[
                _Section(title: 'Portfolio', body: app.portfolioUrl!),
              ],
              if (isStartup) ...[
                const SizedBox(height: 8),
                Text(
                  'Update status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ApplicationStatus.values
                      .where((s) => s != ApplicationStatus.pending)
                      .map(
                        (status) => ActionChip(
                          label: Text(status.label),
                          onPressed: () => _updateStatus(context, ref, app, status),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    Application app,
    ApplicationStatus status,
  ) async {
    await ref.read(applicationStatusControllerProvider.notifier).updateStatus(
          application: app,
          status: status,
        );
    if (!context.mounted) return;
    final state = ref.read(applicationStatusControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        AppSnackbar.error(
          context,
          error is Failure ? error.message : 'Could not update status.',
        );
      },
      data: (_) => AppSnackbar.success(context, 'Status updated.'),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}
