import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/opportunity_card.dart';
import '../../opportunities/presentation/opportunity_controllers.dart';
import '../../opportunities/presentation/opportunity_providers.dart';

class StartupDashboardScreen extends ConsumerWidget {
  const StartupDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(currentStartupProvider).value;
    final opportunitiesAsync = ref.watch(startupOpportunitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Startup dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createOpportunity),
        icon: const Icon(Icons.add),
        label: const Text('Post'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            startup?.name ?? 'Your startup',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                startup?.industry ?? '',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              if (startup?.verified == true) ...[
                const SizedBox(width: 8),
                const Icon(Icons.verified, color: AppColors.success, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Your opportunities',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          opportunitiesAsync.when(
            loading: () => const AppLoading(),
            error: (_, _) => const AppEmptyState(
              title: 'Could not load opportunities',
              icon: Icons.error_outline,
            ),
            data: (items) {
              if (items.isEmpty) {
                return const AppEmptyState(
                  title: 'No opportunities posted',
                  message: 'Post your first internship to attract students.',
                  icon: Icons.work_outline,
                );
              }
              return Column(
                children: items.map((opp) {
                  return OpportunityCard(
                    opportunity: opp,
                    showStartup: false,
                    onTap: () =>
                        context.push(AppRoutes.opportunityDetail(opp.id)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          context.push(AppRoutes.editOpportunity(opp.id));
                        } else if (value == 'delete') {
                          await ref
                              .read(opportunityFormControllerProvider.notifier)
                              .delete(opp.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
