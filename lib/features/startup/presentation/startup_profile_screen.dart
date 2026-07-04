import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/opportunity_card.dart';
import '../../../shared/widgets/verified_badge.dart';
import '../../opportunities/presentation/opportunity_providers.dart';

class StartupProfileScreen extends ConsumerWidget {
  const StartupProfileScreen({super.key, required this.startupId});

  final String startupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupAsync = ref.watch(startupByIdProvider(startupId));
    final opportunitiesAsync =
        ref.watch(startupPublicOpportunitiesProvider(startupId));

    return startupAsync.when(
      loading: () =>
          const Scaffold(body: AppLoading(label: 'Loading startup...')),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load startup')),
      ),
      data: (startup) {
        if (startup == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Startup not found')),
          );
        }

        final opportunities = opportunitiesAsync.value ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('Startup profile')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: startup.logoUrl != null
                        ? CachedNetworkImageProvider(startup.logoUrl!)
                        : null,
                    child: startup.logoUrl == null
                        ? const Icon(Icons.business, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                startup.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            if (startup.verified) ...[
                              const SizedBox(width: 8),
                              const VerifiedBadge(compact: true),
                            ],
                          ],
                        ),
                        Text(
                          startup.industry,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(startup.description),
              const SizedBox(height: 12),
              Text('Founder: ${startup.founderName}'),
              Text('Team size: ${startup.teamSize}'),
              if (startup.website != null) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(startup.website!)),
                  child: Text(
                    startup.website!,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Open opportunities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              if (opportunities.isEmpty)
                Text(
                  'No open opportunities right now.',
                  style: TextStyle(color: AppColors.textSecondary),
                )
              else
                ...opportunities.map(
                  (opp) => OpportunityCard(
                    opportunity: opp,
                    showStartup: false,
                    onTap: () =>
                        context.push(AppRoutes.opportunityDetail(opp.id)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
