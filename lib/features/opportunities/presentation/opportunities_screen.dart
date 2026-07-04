import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loading.dart';
import '../../../shared/widgets/opportunity_card.dart';
import '../../bookmarks/presentation/bookmark_providers.dart';
import '../../onboarding/presentation/onboarding_options.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/models/opportunity.dart';
import 'opportunity_providers.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() =>
      _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  final _searchController = TextEditingController();
  bool _showBookmarksOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    final filters = ref.read(opportunityFiltersProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _FilterSheet(initial: filters);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final opportunitiesAsync = ref.watch(opportunitiesProvider);
    final bookmarksAsync = ref.watch(bookmarkedIdsProvider);
    final isStartup = profile?.role == UserRole.startup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        actions: [
          IconButton(
            icon: Icon(
              _showBookmarksOnly ? Icons.bookmark : Icons.bookmark_outline,
            ),
            onPressed: profile?.role == UserRole.student
                ? () => setState(() => _showBookmarksOnly = !_showBookmarksOnly)
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openFilters,
          ),
        ],
      ),
      floatingActionButton: isStartup
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.createOpportunity),
              icon: const Icon(Icons.add),
              label: const Text('Post'),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(opportunityFiltersProvider.notifier).update(
                      ref.read(opportunityFiltersProvider)
                          .copyWith(searchQuery: value),
                    );
              },
            ),
          ),
          Expanded(
            child: opportunitiesAsync.when(
              loading: () => const AppLoading(label: 'Loading opportunities...'),
              error: (error, _) => AppErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(opportunitiesProvider),
              ),
              data: (items) {
                final bookmarkIds = bookmarksAsync.value ?? {};
                var visible = items;
                if (_showBookmarksOnly) {
                  visible =
                      items.where((o) => bookmarkIds.contains(o.id)).toList();
                }

                if (visible.isEmpty) {
                  return AppEmptyState(
                    title: _showBookmarksOnly
                        ? 'No saved opportunities'
                        : 'No opportunities found',
                    message: _showBookmarksOnly
                        ? 'Bookmark internships to see them here.'
                        : 'Try adjusting your search or filters.',
                    icon: Icons.work_outline,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final opp = visible[index];
                    final isBookmarked = bookmarkIds.contains(opp.id);
                    return OpportunityCard(
                      opportunity: opp,
                      onTap: () =>
                          context.push(AppRoutes.opportunityDetail(opp.id)),
                      trailing: profile?.role == UserRole.student
                          ? IconButton(
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline,
                                color: isBookmarked
                                    ? AppColors.accent
                                    : AppColors.textTertiary,
                              ),
                              onPressed: () => ref
                                  .read(bookmarkToggleProvider.notifier)
                                  .toggle(opp.id),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet({required this.initial});

  final OpportunityFilters initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filters = initial;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Filters & sort',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                initialValue: filters.industry,
                decoration: const InputDecoration(labelText: 'Industry'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any')),
                  ...OnboardingOptions.industries.map(
                    (i) => DropdownMenuItem(value: i, child: Text(i)),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => filters = filters.copyWith(
                          industry: value,
                          clearIndustry: value == null,
                        )),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InternshipType?>(
                initialValue: filters.internshipType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any')),
                  ...InternshipType.values.map(
                    (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => filters = filters.copyWith(
                          internshipType: value,
                          clearType: value == null,
                        )),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<WorkMode?>(
                initialValue: filters.workMode,
                decoration: const InputDecoration(labelText: 'Work mode'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any')),
                  ...WorkMode.values.map(
                    (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => filters = filters.copyWith(
                          workMode: value,
                          clearWorkMode: value == null,
                        )),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Posted in last 7 days'),
                value: filters.recentOnly,
                onChanged: (value) =>
                    setState(() => filters = filters.copyWith(recentOnly: value)),
              ),
              const SizedBox(height: 8),
              SegmentedButton<OpportunitySort>(
                segments: const [
                  ButtonSegment(
                    value: OpportunitySort.newest,
                    label: Text('Newest'),
                  ),
                  ButtonSegment(
                    value: OpportunitySort.deadline,
                    label: Text('Deadline'),
                  ),
                ],
                selected: {filters.sort},
                onSelectionChanged: (selection) => setState(
                  () => filters = filters.copyWith(sort: selection.first),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(opportunityFiltersProvider.notifier).reset();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(opportunityFiltersProvider.notifier)
                            .update(filters);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
