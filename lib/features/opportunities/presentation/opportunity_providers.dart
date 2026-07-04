import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import '../../startup/data/models/startup_profile.dart';
import '../data/models/opportunity.dart';

class OpportunityFiltersNotifier extends Notifier<OpportunityFilters> {
  @override
  OpportunityFilters build() => const OpportunityFilters();

  void update(OpportunityFilters filters) => state = filters;

  void reset() => state = const OpportunityFilters();
}

final opportunityFiltersProvider =
    NotifierProvider<OpportunityFiltersNotifier, OpportunityFilters>(
  OpportunityFiltersNotifier.new,
);

final opportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final repo = ref.watch(opportunityRepositoryProvider);
  final filters = ref.watch(opportunityFiltersProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchOpportunities(filters: filters);
});

final opportunityProvider =
    StreamProvider.family<Opportunity?, String>((ref, id) {
  final repo = ref.watch(opportunityRepositoryProvider);
  if (repo == null) return Stream.value(null);
  return repo.watchOpportunity(id);
});

final startupPublicOpportunitiesProvider =
    StreamProvider.family<List<Opportunity>, String>((ref, startupId) {
  final repo = ref.watch(opportunityRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchOpportunitiesByStartup(startupId);
});

final startupOpportunitiesProvider =
    StreamProvider<List<Opportunity>>((ref) {
  final repo = ref.watch(opportunityRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value([]);
  return repo.watchStartupOpportunities(uid);
});

final currentStartupProvider = StreamProvider<StartupProfile?>((ref) {
  final repo = ref.watch(startupRepositoryProvider);
  final uid = ref.watch(authStateProvider).value?.uid;
  if (repo == null || uid == null) return Stream.value(null);
  return repo.watchStartupByFounder(uid);
});

final startupByIdProvider =
    StreamProvider.family<StartupProfile?, String>((ref, id) {
  final repo = ref.watch(startupRepositoryProvider);
  if (repo == null) return Stream.value(null);
  return repo.watchStartup(id);
});

final recommendedOpportunitiesProvider =
    Provider<List<Opportunity>>((ref) {
  final opportunities = ref.watch(opportunitiesProvider).value ?? [];
  final profile = ref.watch(currentUserProfileProvider).value;
  if (profile == null || profile.skills.isEmpty) {
    return opportunities.take(5).toList();
  }

  final userSkills = profile.skills.map((s) => s.toLowerCase()).toSet();
  final scored = opportunities.map((opp) {
    final matchCount = opp.skillsRequired
        .where((skill) => userSkills.contains(skill.toLowerCase()))
        .length;
    return (opp, matchCount);
  }).toList();

  scored.sort((a, b) => b.$2.compareTo(a.$2));
  return scored.map((e) => e.$1).take(5).toList();
});
