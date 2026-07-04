import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/verified_badge.dart';
import '../../applications/presentation/application_providers.dart';
import '../../bookmarks/presentation/bookmark_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import 'opportunity_providers.dart';

class OpportunityDetailScreen extends ConsumerWidget {
  const OpportunityDetailScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunityAsync = ref.watch(opportunityProvider(opportunityId));
    final profile = ref.watch(currentUserProfileProvider).value;
    final hasAppliedAsync = ref.watch(hasAppliedProvider(opportunityId));
    final startupAsync =
        ref.watch(startupByIdProvider(opportunityAsync.value?.startupId ?? ''));

    return opportunityAsync.when(
      loading: () =>
          const Scaffold(body: AppLoading(label: 'Loading opportunity...')),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load opportunity')),
      ),
      data: (opp) {
        if (opp == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Opportunity not found')),
          );
        }

        final isStudent = profile?.role == UserRole.student;
        final isOwner = profile?.uid == opp.startupId;
        final isVerified = startupAsync.value?.verified ?? false;
        final dateFormat = DateFormat('MMM d, yyyy');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Opportunity'),
            actions: [
              if (isStudent)
                IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () => ref
                      .read(bookmarkToggleProvider.notifier)
                      .toggle(opp.id),
                ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.push(AppRoutes.editOpportunity(opp.id)),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                opp.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () =>
                    context.push(AppRoutes.startupProfile(opp.startupId)),
                child: Row(
                  children: [
                    Text(
                      opp.startupName,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 8),
                      const VerifiedBadge(compact: true),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(opp.workMode.label)),
                  Chip(label: Text(opp.internshipType.label)),
                  Chip(label: Text(opp.duration)),
                  Chip(label: Text('Deadline ${dateFormat.format(opp.deadline)}')),
                ],
              ),
              const SizedBox(height: 20),
              _Section(title: 'Description', body: opp.description),
              _Section(title: 'Responsibilities', body: opp.responsibilities),
              _Section(title: 'Benefits', body: opp.benefits),
              if (opp.skillsRequired.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Skills required',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: opp.skillsRequired
                      .map((s) => Chip(label: Text(s)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 24),
              if (isStudent)
                hasAppliedAsync.when(
                  loading: () => const AppPrimaryButton(
                    label: 'Apply',
                    onPressed: null,
                    isLoading: true,
                  ),
                  error: (_, _) => AppPrimaryButton(
                    label: 'Apply now',
                    onPressed: () =>
                        context.push(AppRoutes.applyToOpportunity(opp.id)),
                  ),
                  data: (hasApplied) => AppPrimaryButton(
                    label: hasApplied ? 'Already applied' : 'Apply now',
                    onPressed: hasApplied
                        ? null
                        : () =>
                            context.push(AppRoutes.applyToOpportunity(opp.id)),
                  ),
                ),
            ],
          ),
        );
      },
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
          Text(body, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
