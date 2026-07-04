import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/opportunity_card.dart';
import '../../applications/presentation/application_providers.dart';
import '../../opportunities/presentation/opportunity_providers.dart';
import '../../profile/presentation/profile_providers.dart';

class HomeFeedScreen extends ConsumerWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final isStartup = profile?.role == UserRole.startup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Launchpad'),
        actions: [
          if (profile?.role == UserRole.admin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () => context.push(AppRoutes.admin),
            ),
        ],
      ),
      body: isStartup ? const _StartupHome() : const _StudentHome(),
    );
  }
}

class _StudentHome extends ConsumerWidget {
  const _StudentHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final recommended = ref.watch(recommendedOpportunitiesProvider);
    final opportunitiesAsync = ref.watch(opportunitiesProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Hi, ${profile?.fullName?.split(' ').first ?? 'there'} 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Discover internships matched to your skills.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Text(
          'Recommended for you',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        if (recommended.isEmpty)
          const AppEmptyState(
            title: 'No recommendations yet',
            message: 'Browse opportunities to get started.',
            icon: Icons.auto_awesome_outlined,
          )
        else
          ...recommended.map(
            (opp) => OpportunityCard(
              opportunity: opp,
              onTap: () => context.push(AppRoutes.opportunityDetail(opp.id)),
            ),
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently posted',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See all'),
            ),
          ],
        ),
        opportunitiesAsync.when(
          loading: () => const AppLoading(),
          error: (_, _) => const AppEmptyState(
            title: 'Could not load opportunities',
            icon: Icons.error_outline,
          ),
          data: (items) {
            if (items.isEmpty) {
              return const AppEmptyState(
                title: 'No opportunities yet',
                message: 'Check back soon for new postings.',
                icon: Icons.work_outline,
              );
            }
            return Column(
              children: items
                  .take(5)
                  .map(
                    (opp) => OpportunityCard(
                      opportunity: opp,
                      onTap: () =>
                          context.push(AppRoutes.opportunityDetail(opp.id)),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _StartupHome extends ConsumerWidget {
  const _StartupHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(currentStartupProvider).value;
    final myOpps = ref.watch(startupOpportunitiesProvider);
    final applications = ref.watch(startupApplicationsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          startup?.name ?? 'Your startup',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage opportunities and review applicants.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Open roles',
                value: myOpps.value?.length.toString() ?? '0',
                icon: Icons.work_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Applicants',
                value: applications.value?.length.toString() ?? '0',
                icon: Icons.people_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => context.push(AppRoutes.createOpportunity),
          icon: const Icon(Icons.add),
          label: const Text('Post new opportunity'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.startupDashboard),
          icon: const Icon(Icons.dashboard_outlined),
          label: const Text('Startup dashboard'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(label, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
